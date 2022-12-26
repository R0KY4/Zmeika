﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
НачальнаяПозиция=44;                 //Учтанавливаем начальную позицию
Змейка.Добавить(44);
НачальноеНаправление=2;                       //Задаем начальное направление 
Пройдено=0; 
Яблоко=1;
КонецПроцедуры


&НаКлиентеНаСервере
Процедура НачатьИгру(Команда)
	Для Счетчик = 1 По 100 Цикл
		Элементы["Декорация"+Счетчик].Гиперссылка=Ложь;
	КонецЦикла;
	Элементы.Вверх.Доступность=Истина;
	Элементы.Вниз.Доступность=Истина;
	Элементы.Вправо.Доступность=Истина;
	Элементы.Влево.Доступность=Истина; 
	ВыборПоложения=Ложь;
	ОчиститьКружок(Яблоко);
	Яблоко=1;
	Змей=Змейка.ВыгрузитьЗначения();
	Стена=Стены.ВыгрузитьЗначения();
	Если Змей.Количество()>0 Тогда
		Для Каждого Номер Из Змей Цикл
			ОчиститьКружок(Номер);
		КонецЦикла;
	КонецЕсли;
	Если СмертьОтСтены=Истина И ДобавитьСтены=Ложь Тогда
		ПокраитьСтену(Змей[0]);
		СмертьОтСтены=Ложь;
	КонецЕсли;
	ДобавитьСтены=Ложь;
	Счет=0;
	Секунды=0;
	ОчиститьКружок(Яблоко);
	Для Каждого Ст Из Стена Цикл
		ПокраитьСтену(Ст);
	КонецЦикла;
	УникальностьЯблока=Ложь;
	Змейка.Очистить();
	Направление=НачальноеНаправление;
	Змейка.Вставить(0,НачальнаяПозиция);
	СделатьСтрелкой(НачальнаяПозиция);
	Яблоко();                            //Генерируем первое яблоко
	ПодключитьОбработчикОжидания("Ход",1);//Подключаем основной код игры он будет выполнятся каждую секунду
КонецПроцедуры

&НаКлиенте
Процедура Ход() 
	СменаНаправления=Ложь;
	Стена=Стены.ВыгрузитьЗначения(); //Выгружаем элементы стен из списка значений в массив
	Змей=Змейка.ВыгрузитьЗначения(); //Выгружаем элементы змейки из списка значений в массив
	Если Змей[0]=Яблоко Тогда        //Фиксируем сбор яблока
		Яблочко=Яблочко+1;
		Если Яблочко=10 И Уровни=Истина Тогда   //Фиксируем сбор 10 яблок в режиме прохождения уровней 
			ОтключитьОбработчикОжидания("Ход"); //и запускаем следующий уровень
			Счет=Счет+1;
			Яблочко=0;
			Пройдено=Пройдено+1;
			Змей[0]=Змей[1];
			СтеныУровней();
			УровеньПройден=Истина;
			ПоказатьПредупреждение(,"Поздравляем! Вы прошли уровень "+Пройдено + "!",,"Уровень пройден!"); 
		Иначе                        //Добавляем сегмент к змейке, генерируем новое яблоко и увеличиваем счет
			Змей.Добавить(0);
			Яблоко();
			Счет=Счет+1;
		КонецЕсли;
	Иначе
		ОчиститьКружок(Змей[Змей.Количество()-1]);//Меняем последний сегмент с прошлого хода на пустой кружок
	КонецЕсли;
		Для Номер=1 По Змей.Количество()-1 Цикл
		Змей[Змей.Количество()-Номер]=Змей[Змей.Количество()-Номер-1];
	КонецЦикла;    //Все занчения сегментов тела змейки(если они есть) меняем на значение элемента перед ним
	Если Направление=1 Тогда
		Если Змей[0]<=10 Тогда
			Змей[0]=Змей[0]+90;
		Иначе
			Змей[0]=Змей[0]-10
		КонецЕсли;
	ИначеЕсли Направление=2 Тогда 
		Если Змей[0]%10=0 Тогда
			Змей[0]=Змей[0]-9;
		Иначе
			Змей[0]=Змей[0]+1;
		КонецЕсли;
	ИначеЕсли Направление=3 Тогда   //Передвигаем голову на одну ячейку согластно направлению
		Если Змей[0]>90 Тогда       //+перенос змейки если она на краю поля
			Змей[0]=Змей[0]-90;
		Иначе
			Змей[0]=Змей[0]+10;
		КонецЕсли;
	ИначеЕсли Направление=4 Тогда
		Если Змей[0]%10=1 Тогда
			Змей[0]=Змей[0]+9;
		Иначе
			Змей[0]=Змей[0]-1;
		КонецЕсли;
	КонецЕсли;
	СменаНаправления=Истина;
	Если УровеньПройден=Ложь Тогда
	СделатьСтрелкой(Змей[0]);               //Меняем голову змейки на стрелку
	Для Номер=2 По Змей.Количество() Цикл
		Если Змей[0]=Змей[Номер-1] Тогда        //Защита от столкновения с хвостом
			ОтключитьОбработчикОжидания("Ход");
			ПоказатьПредупреждение(,"К сожелению, вы врезались в свой хвост(",,"Поражение");
		КонецЕсли
	КонецЦикла;
	Если Змей.Количество()>1 Тогда
		ПокраитьКружок(Змей[1])                 //Меняем стрелку(голову) прошлого хода на кружок(тело змейки)
	КонецЕсли;
	Иначе
	УровеньПройден=Ложь;
	КонецЕсли;
	Для Каждого Номер Из Стена Цикл
		Если Змей[0]=Номер Тогда        //Защита от столкновения со стеной
			ОтключитьОбработчикОжидания("Ход");
			ПоказатьПредупреждение(,"К сожелению, вы врезались прямо в стену(",,"Поражение"); 
			СмертьОтСтены=Истина;
			ПокраитьСтену(Номер);
		КонецЕсли;
	КонецЦикла;
	Змейка.ЗагрузитьЗначения(Змей);  //Загружаем элементы змейки из массива в список значений
	Таймер();//Добовляем секунду к таймеру
	СменаНаправления=Истина;         //Разрешаем смену направления(для того чтобы за ход можно было сменить направление 1 раз)
КонецПроцедуры

Функция Яблоко()                     //Генирирует положение яблока, проверяет, что оно не на теле змейки и расскрашивает его
	Змей=Змейка.ВыгрузитьЗначения();
	Стена=Стены.ВыгрузитьЗначения();
	ГСЧ=Новый ГенераторСлучайныхЧисел;
	Яблоко=ГСЧ.СлучайноеЧисло(1,100);
	УникальностьЯблока=Ложь;
	Пока УникальностьЯблока=Ложь Цикл
		Если Направление=1 Тогда
			Если Змей[0]-10=Яблоко Тогда
				ГСЧ.СлучайноеЧисло(1,100);
				УникальностьЯблока=Ложь;
				Продолжить
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		ИначеЕсли Направление=2 Тогда
			Если Змей[0]+1=Яблоко Тогда
				ГСЧ.СлучайноеЧисло(1,100);
				УникальностьЯблока=Ложь;
				Продолжить
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		ИначеЕсли Направление=3 Тогда
			Если Змей[0]+10=Яблоко Тогда
				ГСЧ.СлучайноеЧисло(1,100);
				УникальностьЯблока=Ложь;
				Продолжить
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		ИначеЕсли Направление=4 Тогда
			Если Змей[0]-1=Яблоко Тогда
				ГСЧ.СлучайноеЧисло(1,100);
				УникальностьЯблока=Ложь;
				Продолжить
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		КонецЕсли;
		Для Каждого Номер Из Змей Цикл
			Если УникальностьЯблока=Ложь Тогда
				Прервать
			ИначеЕсли Яблоко=Номер Тогда
				УникальностьЯблока=Ложь;
				Яблоко=ГСЧ.СлучайноеЧисло(1,100);
				Прервать
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		КонецЦикла;
		Для Каждого Номер Из Стена Цикл
			Если УникальностьЯблока=Ложь Тогда
				Прервать
			ИначеЕсли Яблоко=Номер Тогда
				УникальностьЯблока=Ложь;
				Яблоко=ГСЧ.СлучайноеЧисло(1,100);
				Прервать
			Иначе
				УникальностьЯблока=Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ПокраитьЯблоко(Яблоко);
КонецФункции

Функция Таймер()                     //Считаем время с начала игры и выводим это знначение в подобаемом виде

	Секунды = Секунды+1;
	Если Цел(Секунды / 60 / 60)<10 Тогда
		Час = "0"+Цел(Секунды / 60 / 60);
	Иначе
		Час = Цел(Секунды / 60 / 60);
	КонецЕсли;
	Если Цел((Секунды % 3600) / 60)<10 Тогда
		Мин = "0"+Цел((Секунды % 3600) / 60);
	Иначе
		Мин = Цел((Секунды % 3600) / 60);
	КонецЕсли;
	Если Цел(Секунды % 60)<10 Тогда
		Сек = "0"+Цел(Секунды % 60);
	Иначе
		Сек = Цел(Секунды % 60);
	КонецЕсли;
		Текст = (""+Час+":"+Мин+":"+Сек);
	
	Время = Текст;

КонецФункции // Таймер() 

Функция СделатьСтрелкой(Голова)            //Делаем голову стрелкой согластно направлению движения

	Если Направление=1 Тогда
		Элементы["Декорация" + Голова].Картинка=БиблиотекаКартинок.ПереместитьВверх;
	ИначеЕсли Направление=2 Тогда
		Элементы["Декорация" + Голова].Картинка=БиблиотекаКартинок.ПереместитьВправо;
	ИначеЕсли Направление=3 Тогда
		Элементы["Декорация" + Голова].Картинка=БиблиотекаКартинок.ПереместитьВниз;
	ИначеЕсли Направление=4 Тогда
		Элементы["Декорация" + Голова].Картинка=БиблиотекаКартинок.ПереместитьВлево;
	КонецЕсли;
КонецФункции

Функция ОчиститьКружок(НомерКружка)  //Ставим в ячейку под номером "НомерКружка" пустой кружек
	Элементы["Декорация" + НомерКружка].Картинка=БиблиотекаКартинок.ОформлениеКругПустой;
КонецФункции

Функция ПокраитьКружок(НомерКружка)  //Ставим в ячейку под номером "НомерКружка" заполненый кружек(тело змейки)
	Элементы["Декорация" + НомерКружка].Картинка=БиблиотекаКартинок.ОформлениеКругЗаполненный;
КонецФункции

Функция ПокраитьЯблоко(НомерКружка)  //Ставим в ячейку под номером "НомерКружка" зеленый кружек(яблоко)
	Элементы["Декорация" + НомерКружка].Картинка=БиблиотекаКартинок.ОформлениеКругЗеленый;
КонецФункции

Функция ПокраитьСтену(НомерКружка)  //Ставим в ячейку под номером "НомерКружка" Черный кружек(стену)
	Элементы["Декорация" + НомерКружка].Картинка=БиблиотекаКартинок.ОформлениеКругЧерный;
КонецФункции

Функция ЗакрытиеГиперссылки(НомерКружка)
	Элементы["Декорация"+НомерКружка].Гиперссылка=Ложь;
КонецФункции

&НаКлиенте
Процедура Вверх(Команда)             //Меняем направление на "Вверх" + защита от смены направления на противоположное
	Если СменаНаправления=Истина Тогда
		СменаНаправления=Ложь;
		Элементы.Влево.Доступность=Истина;
		Элементы.Вправо.Доступность=Истина;
		Элементы.Вниз.Доступность=Ложь;
		Направление=1;
	КонецЕсли;
	Если ВыборПоложения=Истина Тогда
		Направление=1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Вправо(Команда)            //Меняем направление на "Вправо" + защита от смены направления на противоположное
	Если СменаНаправления=Истина Тогда
		СменаНаправления=Ложь;
		Элементы.Вверх.Доступность=Истина;
		Элементы.Вниз.Доступность=Истина;
		Элементы.Влево.Доступность=Ложь;
		Направление=2;
	КонецЕсли;
	Если ВыборПоложения=Истина Тогда
		Направление=2;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Вниз(Команда)              //Меняем направление на "Вниз" + защита от смены направления на противоположное
	Если СменаНаправления=Истина Тогда
		СменаНаправления=Ложь;
		Элементы.Влево.Доступность=Истина;
		Элементы.Вправо.Доступность=Истина;
		Элементы.Вверх.Доступность=Ложь;
		Направление=3;
	КонецЕсли;
	Если ВыборПоложения=Истина Тогда
		Направление=3;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Влево(Команда)             //Меняем направление на "Влево" + защита от смены направления на противоположное
	Если СменаНаправления=Истина Тогда
		СменаНаправления=Ложь;
		Элементы.Вверх.Доступность=Истина;
		Элементы.Вниз.Доступность=Истина;
		Элементы.Вправо.Доступность=Ложь;
		Направление=4;
	КонецЕсли;
	Если ВыборПоложения=Истина Тогда
		Направление=4;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборПоложения(Команда)    //Позволяет выбрать начальное положение змейки
	Элементы.Декорация100.Гиперссылка=Ложь;
	Элементы.Вверх.Доступность=Истина;
	Элементы.Вниз.Доступность=Истина;
	Элементы.Вправо.Доступность=Истина;
	Элементы.Влево.Доступность=Истина;
	Уровни=Ложь;
	ОтключитьОбработчикОжидания("Ход");
	ДобавитьСтены=Ложь;
	ВыборПоложения=Истина; 
	Стена=Стены.ВыгрузитьЗначения();
	Змей=Змейка.ВыгрузитьЗначения();
	Для Каждого Номер Из Змей Цикл
		ОчиститьКружок(Номер);
	КонецЦикла;
	Направление=2;
	СделатьСтрелкой(НачальнаяПозиция);
	Для Каждого Номер Из Стена Цикл
		ПокраитьСтену(Номер);
	КонецЦикла;
	ОчиститьКружок(Яблоко);
	Змейка.Очистить();
	Направление=2;
	ПоказатьПредупреждение(,"Установите ваше стартовое положение, нажимая на кружки. Чтобы выбрать направление используйте кнопки направления. Для начала игры нажмите «Начать игру».",,"Изменение стартовой позиции");
	Для Счетчик = 1 По 100 Цикл
		Элементы["Декорация"+Счетчик].Гиперссылка=Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтены(Команда)     //Позволяет добавить свои стены на пустом игровом поле
	ОтключитьОбработчикОжидания("Ход");
	ДобавитьСтены=Истина;
	ВыборПоложения=Ложь;
	Стена=Стены.ВыгрузитьЗначения();
		Змей=Змейка.ВыгрузитьЗначения();
	Для Каждого Номер Из Змей Цикл
		ОчиститьКружок(Номер);
	КонецЦикла;
	Для Каждого Номер Из Стена Цикл
		ОчиститьКружок(Номер);
	КонецЦикла;
	ОчиститьКружок(Яблоко);
		Змейка.Очистить();
		Стены.Очистить();
		Направление=2;
		ПоказатьПредупреждение(,"Установите стены, нажимая на кружки. Для начала игры нажмите «Начать игру». Стены сохранятся до их удаления или повторной установки.",,"Добавление стен");
	Для Счетчик = 1 По 100 Цикл
		Элементы["Декорация"+Счетчик].Гиперссылка=Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтены(Команда)      //Позволяет удалить все стены с игрового поля
	ОтключитьОбработчикОжидания("Ход");
	Уровни=Ложь;
	Стена=Стены.ВыгрузитьЗначения();
	Для Каждого Ст Из Стена Цикл;
		ОчиститьКружок(Ст);
	КонецЦикла;
	Стены.Очистить();
КонецПроцедуры

Функция СтеныУровней()               //Отрисовывает стены в режиме прохождения уровней
	Уровни=Истина;
	Змей=Змейка.ВыгрузитьЗначения();
	Стена=Стены.ВыгрузитьЗначения();
	Для Каждого Номер Из Змей Цикл
				ОчиститьКружок(Номер);
			КонецЦикла;
			Для Каждого Номер Из Стена Цикл
				ОчиститьКружок(Номер);
			КонецЦикла;
			ОчиститьКружок(Яблоко);
	Стены.Очистить(); 
	Стена.Очистить();
	Если Пройдено=0 Тогда 
		Направление=2;
		НачальнаяПозиция=44;
		СделатьСтрелкой(НачальнаяПозиция);
		Для Сч= 1 По 10 Цикл
			Стена.Добавить(Сч);
			Стена.Добавить(Сч*10);
			Стена.Добавить((Сч-1)*10+1);
			Стена.Добавить(Сч+90);
		КонецЦикла;
	ИначеЕсли Пройдено=1 Тогда
		Направление=2;
		НачальнаяПозиция=27;
		СделатьСтрелкой(НачальнаяПозиция);
		Для Сч= 1 По 10 Цикл
			Стена.Добавить(Сч);
			Стена.Добавить(Сч*10);
			Стена.Добавить((Сч-1)*10+1);
			Стена.Добавить(Сч+90);
		КонецЦикла;
		Для Сч=4 По 7 Цикл
			Стена.Добавить(Сч+30);
			Стена.Добавить(Сч+60);
		КонецЦикла;
	ИначеЕсли Пройдено=2 Тогда
		Направление=2;
		НачальнаяПозиция=27;
		СделатьСтрелкой(НачальнаяПозиция);
		Для Сч= 1 По 10 Цикл
			Стена.Добавить(Сч+40);
			Стена.Добавить((Сч*10)-4);
			Стена.Добавить((Сч*10)-5);
			Стена.Добавить(Сч+50);
		КонецЦикла;
	ИначеЕсли Пройдено=3 Тогда
		Направление=2;
		СделатьСтрелкой(13);
		НачальнаяПозиция=13;
		Стена.Добавить(61);
		Стена.Добавить(71);
		Стена.Добавить(81);
		Стена.Добавить(91);
		Стена.Добавить(92);
		Стена.Добавить(93);
		Стена.Добавить(94);
		Стена.Добавить(100);
		Стена.Добавить(98);
		Стена.Добавить(97);
		Стена.Добавить(99);
		Стена.Добавить(90);
		Стена.Добавить(80);
		Стена.Добавить(70);
		Стена.Добавить(1);
		Стена.Добавить(2);
		Стена.Добавить(3);
		Стена.Добавить(4);
		Стена.Добавить(11);
		Стена.Добавить(21);
		Стена.Добавить(31);
		Стена.Добавить(9);
		Стена.Добавить(8);
		Стена.Добавить(7);
		Стена.Добавить(10);
		Стена.Добавить(20);
		Стена.Добавить(30);
		Стена.Добавить(40);
		Для Сч= 3 По 8 Цикл
			Стена.Добавить(Сч+40);
			Стена.Добавить((Сч*10)-4);
			Стена.Добавить((Сч*10)-5);
			Стена.Добавить(Сч+50);
		КонецЦикла;
	ИначеЕсли Пройдено=4 Тогда
		Направление=3;
		НачальнаяПозиция=15;
		СделатьСтрелкой(НачальнаяПозиция);
		Для Сч= 1 По 10 Цикл
			Стена.Добавить(Сч+30);
			Стена.Добавить(Сч*10-3);
			Стена.Добавить((Сч-1)*10+4);
			Стена.Добавить(Сч+60);
		КонецЦикла;
		Стена.Удалить(6);
		Стена.Удалить(5);
		Стена.Удалить(18);
		Стена.Удалить(14);
		Стена.Удалить(15);
		Стена.Удалить(17);
		Стена.Удалить(14);
		Стена.Удалить(15);
	КонецЕсли;
	Для Каждого Ст Из Стена Цикл
		ПокраитьСтену(Ст);
	КонецЦикла;
	Стены.ЗагрузитьЗначения(Стена); 
	Элементы.Вверх.Доступность=Истина;
	Элементы.Вниз.Доступность=Истина;
	Элементы.Влево.Доступность=Истина;
	Элементы.Вправо.Доступность=Истина;
КонецФункции

&НаКлиенте
Процедура Уровни(Команда)            //Запускает режим прохождения уровней
	ОчиститьКружок(НачальнаяПозиция); 
	ОчиститьКружок(Яблоко);
	ОтключитьОбработчикОжидания("Ход");
	СтеныУровней();
КонецПроцедуры

Функция Настройки(Номер)             //Отвечает за работу с ячейками игрового поля
	Если ВыборПоложения=Истина Тогда
		ОчиститьКружок(НачальнаяПозиция);
		Змейка.Очистить();
		СделатьСтрелкой(Номер);
		НачальнаяПозиция=Номер;
		НачальноеНаправление=Направление;
	Иначе
		Стены.Добавить(Номер);
		ПокраитьСтену(Номер);
		ЗакрытиеГиперссылки(Номер);
	КонецЕсли
КонецФункции

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	Настройки(1);
КонецПроцедуры

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	Настройки(2);
КонецПроцедуры

&НаКлиенте
Процедура Декорация3Нажатие(Элемент)
	Настройки(3);
КонецПроцедуры

&НаКлиенте
Процедура Декорация4Нажатие(Элемент)
	Настройки(4);
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	Настройки(5);
КонецПроцедуры  

&НаКлиенте
Процедура Декорация6Нажатие(Элемент)
	Настройки(6);
КонецПроцедуры

&НаКлиенте
Процедура Декорация7Нажатие(Элемент)
	Настройки(7);
КонецПроцедуры

&НаКлиенте
Процедура Декорация8Нажатие(Элемент)
	Настройки(8);
КонецПроцедуры

&НаКлиенте
Процедура Декорация9Нажатие(Элемент)
	Настройки(9);
КонецПроцедуры

&НаКлиенте
Процедура Декорация10Нажатие(Элемент)
	Настройки(10);
КонецПроцедуры

&НаКлиенте
Процедура Декорация11Нажатие(Элемент)
	Настройки(11);
КонецПроцедуры

&НаКлиенте
Процедура Декорация12Нажатие(Элемент)
	Настройки(12);
КонецПроцедуры

&НаКлиенте
Процедура Декорация13Нажатие(Элемент)
	Настройки(13);
КонецПроцедуры

&НаКлиенте
Процедура Декорация14Нажатие(Элемент)
	Настройки(14);
КонецПроцедуры

&НаКлиенте
Процедура Декорация15Нажатие(Элемент)
	Настройки(15);
КонецПроцедуры

&НаКлиенте
Процедура Декорация16Нажатие(Элемент)
	Настройки(16);
КонецПроцедуры

&НаКлиенте
Процедура Декорация17Нажатие(Элемент)
	Настройки(17);
КонецПроцедуры

&НаКлиенте
Процедура Декорация18Нажатие(Элемент)
	Настройки(18);
КонецПроцедуры

&НаКлиенте
Процедура Декорация19Нажатие(Элемент)
	Настройки(19);
КонецПроцедуры

&НаКлиенте
Процедура Декорация20Нажатие(Элемент)
	Настройки(20);
КонецПроцедуры

&НаКлиенте
Процедура Декорация21Нажатие(Элемент)
	Настройки(21);
КонецПроцедуры

&НаКлиенте
Процедура Декорация22Нажатие(Элемент)
	Настройки(22);
КонецПроцедуры

&НаКлиенте
Процедура Декорация23Нажатие(Элемент)
	Настройки(23);
КонецПроцедуры

&НаКлиенте
Процедура Декорация24Нажатие(Элемент)
	Настройки(24);
КонецПроцедуры

&НаКлиенте
Процедура Декорация25Нажатие(Элемент)
	Настройки(25);
КонецПроцедуры

&НаКлиенте
Процедура Декорация26Нажатие(Элемент)
	Настройки(26);
КонецПроцедуры

&НаКлиенте
Процедура Декорация27Нажатие(Элемент)
	Настройки(27);
КонецПроцедуры

&НаКлиенте
Процедура Декорация28Нажатие(Элемент)
	Настройки(28);
КонецПроцедуры

&НаКлиенте
Процедура Декорация29Нажатие(Элемент)
	Настройки(29);
КонецПроцедуры

&НаКлиенте
Процедура Декорация30Нажатие(Элемент)
	Настройки(30);
КонецПроцедуры

&НаКлиенте
Процедура Декорация31Нажатие(Элемент)
	Настройки(31);
КонецПроцедуры

&НаКлиенте
Процедура Декорация32Нажатие(Элемент)
	Настройки(32);
КонецПроцедуры

&НаКлиенте
Процедура Декорация33Нажатие(Элемент)
	Настройки(33);
КонецПроцедуры

&НаКлиенте
Процедура Декорация34Нажатие(Элемент)
	Настройки(34);
КонецПроцедуры

&НаКлиенте
Процедура Декорация35Нажатие(Элемент)
	Настройки(35);
КонецПроцедуры

&НаКлиенте
Процедура Декорация36Нажатие(Элемент)
	Настройки(36);
КонецПроцедуры

&НаКлиенте
Процедура Декорация37Нажатие(Элемент)
	Настройки(37);
КонецПроцедуры

&НаКлиенте
Процедура Декорация38Нажатие(Элемент)
	Настройки(38);
КонецПроцедуры

&НаКлиенте
Процедура Декорация39Нажатие(Элемент)
	Настройки(39);
КонецПроцедуры

&НаКлиенте
Процедура Декорация40Нажатие(Элемент)
	Настройки(40);
КонецПроцедуры

&НаКлиенте
Процедура Декорация41Нажатие(Элемент)
	Настройки(41);
КонецПроцедуры

&НаКлиенте
Процедура Декорация42Нажатие(Элемент)
	Настройки(42);
КонецПроцедуры

&НаКлиенте
Процедура Декорация43Нажатие(Элемент)
	Настройки(43);
КонецПроцедуры

&НаКлиенте
Процедура Декорация44Нажатие(Элемент)
	Настройки(44);
КонецПроцедуры

&НаКлиенте
Процедура Декорация45Нажатие(Элемент)
	Настройки(45);
КонецПроцедуры

&НаКлиенте
Процедура Декорация46Нажатие(Элемент)
	Настройки(46);
КонецПроцедуры

&НаКлиенте
Процедура Декорация47Нажатие(Элемент)
	Настройки(47);
КонецПроцедуры

&НаКлиенте
Процедура Декорация48Нажатие(Элемент)
	Настройки(48);
КонецПроцедуры

&НаКлиенте
Процедура Декорация49Нажатие(Элемент)
	Настройки(49);
КонецПроцедуры

&НаКлиенте
Процедура Декорация50Нажатие(Элемент)
	Настройки(50);
КонецПроцедуры

&НаКлиенте
Процедура Декорация51Нажатие(Элемент)
	Настройки(51);
КонецПроцедуры

&НаКлиенте
Процедура Декорация52Нажатие(Элемент)
	Настройки(52);
КонецПроцедуры

&НаКлиенте
Процедура Декорация53Нажатие(Элемент)
	Настройки(53);
КонецПроцедуры

&НаКлиенте
Процедура Декорация54Нажатие(Элемент)
	Настройки(54);
КонецПроцедуры

&НаКлиенте
Процедура Декорация55Нажатие(Элемент)
	Настройки(55);
КонецПроцедуры

&НаКлиенте
Процедура Декорация56Нажатие(Элемент)
	Настройки(56);
КонецПроцедуры

&НаКлиенте
Процедура Декорация57Нажатие(Элемент)
	Настройки(57);
КонецПроцедуры

&НаКлиенте
Процедура Декорация58Нажатие(Элемент)
	Настройки(58);
КонецПроцедуры

&НаКлиенте
Процедура Декорация59Нажатие(Элемент)
	Настройки(59);
КонецПроцедуры

&НаКлиенте
Процедура Декорация60Нажатие(Элемент)
	Настройки(60);
КонецПроцедуры

&НаКлиенте
Процедура Декорация61Нажатие(Элемент)
	Настройки(61);
КонецПроцедуры

&НаКлиенте
Процедура Декорация62Нажатие(Элемент)
	Настройки(62);
КонецПроцедуры

&НаКлиенте
Процедура Декорация63Нажатие(Элемент)
	Настройки(63);
КонецПроцедуры

&НаКлиенте
Процедура Декорация64Нажатие(Элемент)
	Настройки(64);
КонецПроцедуры

&НаКлиенте
Процедура Декорация65Нажатие(Элемент)
	Настройки(65);
КонецПроцедуры

&НаКлиенте
Процедура Декорация66Нажатие(Элемент)
	Настройки(66);
КонецПроцедуры

&НаКлиенте
Процедура Декорация67Нажатие(Элемент)
	Настройки(67);
КонецПроцедуры

&НаКлиенте
Процедура Декорация68Нажатие(Элемент)
	Настройки(68);
КонецПроцедуры

&НаКлиенте
Процедура Декорация69Нажатие(Элемент)
	Настройки(69);
КонецПроцедуры

&НаКлиенте
Процедура Декорация70Нажатие(Элемент)
	Настройки(70);
КонецПроцедуры

&НаКлиенте
Процедура Декорация71Нажатие(Элемент)
	Настройки(71);
КонецПроцедуры

&НаКлиенте
Процедура Декорация72Нажатие(Элемент)
	Настройки(72);
КонецПроцедуры

&НаКлиенте
Процедура Декорация73Нажатие(Элемент)
	Настройки(73);
КонецПроцедуры

&НаКлиенте
Процедура Декорация74Нажатие(Элемент)
	Настройки(74);
КонецПроцедуры

&НаКлиенте
Процедура Декорация75Нажатие(Элемент)
	Настройки(75);
КонецПроцедуры

&НаКлиенте
Процедура Декорация76Нажатие(Элемент)
	Настройки(76);
КонецПроцедуры

&НаКлиенте
Процедура Декорация77Нажатие(Элемент)
	Настройки(77);
КонецПроцедуры

&НаКлиенте
Процедура Декорация78Нажатие(Элемент)
	Настройки(78);
КонецПроцедуры

&НаКлиенте
Процедура Декорация79Нажатие(Элемент)
	Настройки(79);
КонецПроцедуры

&НаКлиенте
Процедура Декорация80Нажатие(Элемент)
	Настройки(80);
КонецПроцедуры

&НаКлиенте
Процедура Декорация81Нажатие(Элемент)
	Настройки(81);
КонецПроцедуры

&НаКлиенте
Процедура Декорация82Нажатие(Элемент)
	Настройки(82);
КонецПроцедуры

&НаКлиенте
Процедура Декорация83Нажатие(Элемент)
	Настройки(83);
КонецПроцедуры

&НаКлиенте
Процедура Декорация84Нажатие(Элемент)
	Настройки(84);
КонецПроцедуры

&НаКлиенте
Процедура Декорация85Нажатие(Элемент)
	Настройки(85);
КонецПроцедуры

&НаКлиенте
Процедура Декорация86Нажатие(Элемент)
	Настройки(86);
КонецПроцедуры

&НаКлиенте
Процедура Декорация87Нажатие(Элемент)
	Настройки(87);
КонецПроцедуры

&НаКлиенте
Процедура Декорация88Нажатие(Элемент)
	Настройки(88);
КонецПроцедуры

&НаКлиенте
Процедура Декорация89Нажатие(Элемент)
	Настройки(89);
КонецПроцедуры

&НаКлиенте
Процедура Декорация90Нажатие(Элемент)
	Настройки(90);
КонецПроцедуры

&НаКлиенте
Процедура Декорация91Нажатие(Элемент)
	Настройки(91);
КонецПроцедуры

&НаКлиенте
Процедура Декорация92Нажатие(Элемент)
	Настройки(92);
КонецПроцедуры

&НаКлиенте
Процедура Декорация93Нажатие(Элемент)
	Настройки(93);
КонецПроцедуры

&НаКлиенте
Процедура Декорация94Нажатие(Элемент)
	Настройки(94);
КонецПроцедуры

&НаКлиенте
Процедура Декорация95Нажатие(Элемент)
	Настройки(95);
КонецПроцедуры

&НаКлиенте
Процедура Декорация96Нажатие(Элемент)
	Настройки(96);
КонецПроцедуры

&НаКлиенте
Процедура Декорация97Нажатие(Элемент)
	Настройки(97);
КонецПроцедуры

&НаКлиенте
Процедура Декорация98Нажатие(Элемент)
	Настройки(98);
КонецПроцедуры

&НаКлиенте
Процедура Декорация99Нажатие(Элемент)
	Настройки(99);
КонецПроцедуры

&НаКлиенте
Процедура Декорация100Нажатие(Элемент)
	Настройки(100);
КонецПроцедуры


