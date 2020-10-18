% DOOMSDAY ALGORITHM %

% STEP 1 %
day(sun,0).
day(mon,1).
day(tue,2).
day(wed,3).
day(thu,4).
day(fri,5).
day(sat,6).

% STEP 2 %
doomsday_by_century(10,5):- !.
doomsday_by_century(11,3):- !.
doomsday_by_century(12,2):- !.
doomsday_by_century(13,0):- !.

doomsday_by_century(YY,DOOMSDAY):- 
	YY >= 10,
	PREV_YY is YY - 4,
	doomsday_by_century(PREV_YY,DOOMSDAY).

% STEP 3 %
doomsday(1,3):- !.
doomsday(2,7):- !. 
doomsday(3,7):- !.
doomsday(4,4):- !.
doomsday(5,2):- !.
doomsday(6,6):- !.
doomsday(7,4):- !.
doomsday(8,1):- !.
doomsday(9,5):- !.
doomsday(10,3):- !.
doomsday(11,6):- !.
doomsday(12,5):- !.

doomsday(MM,DD):- 
	DD =< 31,
	NEXT is DD - 7,
	NEXT >= 1,
	doomsday(MM,NEXT).

days_after_doomsday(MM,DD,0):- doomsday(MM,DD), !.
days_after_doomsday(MM,DD,NDAYS):- 
	DD >= 1,
	DAYBEFORE is DD - 1,
	days_after_doomsday(MM,DAYBEFORE,XX),
	NDAYS is XX + 1.

% STEP 4 %

red_by(X,BY,X):- X<BY, !.
red_by(X,BY,RES):- Y is X - BY, red_by(Y,BY,RES).

last_two_digit(YYYY,Y):-Y is mod(YYYY,100).
first_two_digit(YYYY,Y):-Y is div(YYYY,100).

% compute_year_param(1969,CODE,DOZENS,REMAINDER,AND)
compute_year_param(YYYY,DOOMSDAY_BY_CENTURY,DOZENS,REMAINDER,AND):-
	last_two_digit(YYYY,LAST),
	first_two_digit(YYYY,FIRST),
	doomsday_by_century(FIRST,DOOMSDAY_BY_CENTURY),
	DOZENS is div(LAST,12),
	REMAINDER is LAST - 12 * DOZENS,
	AND is div(REMAINDER,4).

% STEP 5 %

% doomsday_of_year(1776,DOOMSDAY)
doomsday_of_year(YYYY,DOOMSDAY):-
	compute_year_param(YYYY,DOOMSDAY_BY_CENTURY,DOZENS,REMAINDER,AND),
	RES is DOOMSDAY_BY_CENTURY + DOZENS + REMAINDER + AND,
	red_by(RES,7,DOOMSDAY).

% move_to_date(7,4,1776,DATE_NUM)
move_to_date(MM,DD,YYYY,DATE_NUM):-
	doomsday_of_year(YYYY,DOOMSDAY),
	days_after_doomsday(MM,DD,DAY_AFTER),
	SHIFT is DOOMSDAY + DAY_AFTER,
	red_by(SHIFT,7,DATE_NUM).

% STEP 6 %

% what_day_is(10,12,1492,DISCOVERY_OF_AMERICA) (wednesday) ==> what_day_is(10,12,1492,DISCOVERY_OF_AMERICA), DISCOVERY_OF_AMERICA == wed
% what_day_is(7,28,1914,FIRST_WORLD_WAR_BEGUN) (tuesday) ==> what_day_is(7,28,1914,FIRST_WORLD_WAR_BEGUN), FIRST_WORLD_WAR_BEGUN == tue
% what_day_is(7,20,1969,MOON_LANDING) (sunday) ==> what_day_is(7,20,1969,MOON_LANDING), MOON_LANDING == sun
what_day_is(MM,DD,YYYY,DAY):- 
	move_to_date(MM,DD,YYYY,DATE_NUM), 
	day(DAY,DATE_NUM).



