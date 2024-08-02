#Область ОбработчикиСобытий

// Обработчик команды печати.
//
// Параметры:
//	ПараметрКоманды - Произвольный - содержит ссылку на объект, для которого вызвана команда печати.
//	ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - параметры выполнения команды.
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Билет)
	ТабДок = Новый ТабличныйДокумент;
	Билет(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	//}}
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик команды печати на сервере.
//
// Параметры:
//	ТабДок - ТабличныйДокумент - табличный документ для заполнения и печати.
//	ПараметрКоманды - Произвольный - содержит ссылку на объект, для которого вызвана команда печати.
&НаСервере
Процедура Билет(ТабДок, ПараметрКоманды)
	Документы.ПродажаБилета.Билет(ТабДок, ПараметрКоманды);
КонецПроцедуры

#КонецОбласти
