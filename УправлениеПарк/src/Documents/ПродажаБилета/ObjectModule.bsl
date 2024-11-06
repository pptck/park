// @strict-types


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ,Режим)
	
	Движения.АктивныеПосещения.Записывать = Истина;
	Движения.Продажи.Записывать = Истина;


	Запрос = Новый Запрос();
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажаБилетаПозицииПродажи.Номенклатура.ВидАттракциона КАК ВидАттракциона,
		|	ПродажаБилетаПозицииПродажи.Номенклатура.КоличествоПоосещений * ПродажаБилетаПозицииПродажи.Количество КАК
		|		КоличествоПоосещений,
		|	ПродажаБилетаПозицииПродажи.Сумма,
		|	ПродажаБилетаПозицииПродажи.Номенклатура КАК Номенклатура
		|ИЗ
		|	Документ.ПродажаБилета.ПозицииПродажи КАК ПродажаБилетаПозицииПродажи
		|ГДЕ
		|	ПродажаБилетаПозицииПродажи.Ссылка = &Ссылка";
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
	
		// регистр АктивныеПосещения
		АктивныеПосещения = Движения.АктивныеПосещения.Добавить();
		АктивныеПосещения.Период = Дата;
		АктивныеПосещения.ВидДвижения = ВидДвиженияНакопления.Приход;
		АктивныеПосещения.Основание = Ссылка;
		АктивныеПосещения.ВидАттракциона = Выборка.ВидАттракциона;
		АктивныеПосещения.КоличествоПосещений = Выборка.КоличествоПоосещений;
	
		// регистр Продажи
		ДвижениеПродажи = Движения.Продажи.Добавить();
		ДвижениеПродажи.Период = Дата;
		ДвижениеПродажи.ВидАттракциона = Выборка.ВидАттракциона;
		ДвижениеПродажи.Номенклатура = Выборка.Номенклатура;
		ДвижениеПродажи.Клиент = Клиент;
		ДвижениеПродажи.Сумма = Выборка.Сумма;
	
	КонецЦикла;
	
	НачислитьСписатьБонусныеБаллы(Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МаксимальнаяДоля = Константы.МаксивальнаяДоляОплатыБаллами.Получить();
	
	СуммаПродажи = ПозицииПродажи.Итог("Сумма");
	
	Если БаллыКСписанию <> 0 Тогда
		
		Если БаллыКСписанию > СуммаПродажи Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Списываемые баллы не должны превышать сумму продажи";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "БаллыКСписанию";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если СуммаПродажи <> 0 Тогда
			Доля = БаллыКСписанию / СуммаПродажи * 100;
			Если Доля > МаксимальнаяДоля Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = СтрШаблон("Доля списываемых баллов от сумму продажи больше допустимой (%1%%)", МаксимальнаяДоля);
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "БаллыКСписанию";
				Сообщение.Сообщить();				
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Клиент) Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = СтрШаблон("Для списания баллов необходимо указать клиента");
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "Клиент";
				Сообщение.Сообщить();
		КонецЕсли;		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачислитьСписатьБонусныеБаллы(Отказ)
	
	Движения.БонусныеБаллыКлентов.Записывать = Истина;
	
	Если Не ЗначениеЗаполнено(Клиент) Тогда
		Возврат;
	КонецЕсли;
	
	СуммаПокупокКлиента = СуммаПокупокКлиента(); 
	
	ДоляНакапливаемыхБаллов = ДоляНакапливаемыхБаллов(СуммаПокупокКлиента); 
	
	БаллыКНакоплению = СуммаДокумента * ДоляНакапливаемыхБаллов / 100;
	
	Если БаллыКНакоплению <> 0 Тогда
		
		Движение = Движения.БонусныеБаллыКлентов.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Сумма = БаллыКНакоплению;
				
	КонецЕсли;
	
	Если БаллыКСписанию <> 0 Тогда
		Движение = Движения.БонусныеБаллыКлентов.ДобавитьРасход();
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Сумма = БаллыКСписанию;		
	КонецЕсли;
	
	Движения.Записать();
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БонусныеБаллыКлентовОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.БонусныеБаллыКлентов.Остатки(&Период, Клиент = &Клиент) КАК БонусныеБаллыКлентовОстатки
		|ГДЕ
		|	БонусныеБаллыКлентовОстатки.СуммаОстаток < 0";
		
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(),ВидГраницы.Включая));		
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Следующий() Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = СтрШаблон("Не хватает баллов для списания, на балансе %1", Выборка.СуммаОстаток - Окр(БаллыКНакоплению) + БаллыКСписанию);
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "БаллыКСписанию";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

Функция СуммаПокупокКлиента()

	
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажиОбороты.СуммаОборот
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(, &КонецПериода,, Клиент = &Клиент) КАК ПродажиОбороты";
		
	Запрос.УстановитьПараметр("КонецПериода", Новый Граница(МоментВремени(), ВидГраницы.Исключая));		
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СуммаОборот;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции	

Функция ДоляНакапливаемыхБаллов(СуммаПокупок)
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШкалаБонуснойПрограммыДиапазоны.ПроцентНакоплений
		|ИЗ
		|	РегистрСведений.АктуальнаяШкалаБонуснойПрограммы.СрезПоследних(&Период,) КАК
		|		АктуальнаяШкалаБонуснойПрограммыСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ШкалаБонуснойПрограммы.Диапазоны КАК ШкалаБонуснойПрограммыДиапазоны
		|		ПО АктуальнаяШкалаБонуснойПрограммыСрезПоследних.Шкала = ШкалаБонуснойПрограммыДиапазоны.Ссылка
		|ГДЕ
		|	ШкалаБонуснойПрограммыДиапазоны.НижняяГраница <= &СуммаПокупок
		|	И (ШкалаБонуснойПрограммыДиапазоны.ВерхняяГраница > &СуммаПокупок
		|	ИЛИ ШкалаБонуснойПрограммыДиапазоны.ВерхняяГраница = 0)";
		
	Запрос.УстановитьПараметр("Период", Дата);		
	Запрос.УстановитьПараметр("СуммаПокупок", СуммаПокупок);
	
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПроцентНакоплений;
	КонецЕсли;
	
	Возврат 0;
		
КонецФункции
#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
