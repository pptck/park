// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// 1. Нижняя граница первого диапазона должна быть равна 0
	// 2. Верхняя граница каждого диапазона, кроме последнего,  должна быть равна нижней следующего
	// 3. Верхняя граница всегда больше нижней границы (кроме последнего диапазона)	//
	// 4. Верхняя граница последнего диапазона должна быть равна 0

	
	Если Диапазоны.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Диапазоны[0].НижняяГраница <> 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = СтрШаблон("Нижняя граница первого диапазона должна быть = 0");
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Диапазоны[0].НижняяГраница";
		Сообщение.Сообщить();				
	КонецЕсли;
	
	ВерхняяГраницаПредыдущегоДиапазона = 0;
	
	Для Сч = 0 По Диапазоны.Количество() - 1 Цикл
		
		Диапазон = Диапазоны[Сч];
		
		Если Сч > 0 Тогда
			Если Диапазон.НижняяГраница <> ВерхняяГраницаПредыдущегоДиапазона Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = СтрШаблон("Верхняя граница должна быть равна нижней следующего");
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = СтрШаблон("Диапазоны[%1].НижняяГраница", XMLСтрока(Сч));
				Сообщение.Сообщить();
			КонецЕсли;					
		КонецЕсли;
		
		Если Диапазон.НижняяГраница >= Диапазон.ВерхняяГраница и Сч <> Диапазоны.Количество() - 1 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = СтрШаблон("Верхняя граница должна быть больше нижней");
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = СтрШаблон("Диапазоны[%1].ВерхняяГраница", XMLСтрока(Сч));
			Сообщение.Сообщить();
		КонецЕсли;
		
		ВерхняяГраницаПредыдущегоДиапазона = Диапазон.ВерхняяГраница;
		
	КонецЦикла;
	
	ПоследнийДиапазон = Диапазоны[Диапазоны.Количество() - 1];

	Если ПоследнийДиапазон.ВерхняяГраница <> 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = СтрШаблон("Верхняя граница первого диапазона должна быть = 0");
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = СтрШаблон("Диапазоны[%1].ВерхняяГраница", XMLСтрока(Диапазоны.Количество() - 1));
		Сообщение.Сообщить();				
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ,Режим)

	// регистр АктуальнаяШкалаБонуснойПрограммы
	Движения.АктуальнаяШкалаБонуснойПрограммы.Записывать = Истина;
	Движение = Движения.АктуальнаяШкалаБонуснойПрограммы.Добавить();
	Движение.Период = Дата;
	Движение.Шкала = Ссылка;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
