
&НаСервере
Процедура ОчиститьНаСервере()
	Набор = РегистрыСведений.ТС_ИзбранныеТесты.СоздатьНаборЗаписей();
	Набор.Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьНаСервере();
КонецПроцедуры
