create schema music;

create table music.users
(
    user_id  integer primary key,
    user_nm  varchar(50) not null,
    birth_dt date
);

create table music.validate_user_data
(
    user_id         integer,
    card_nm         varchar(16),
    mail_nm         varchar(50) not null,
    subscr_type     varchar(50) not null,
    valid_from_dttm timestamp default now(),
    valid_to_dttm   timestamp default now() + interval '1 year',

    foreign key (user_id) references music.users (user_id) on delete cascade,
    constraint subscr_version primary key (user_id, valid_from_dttm)
);

create table music.tracks
(
    track_id     integer primary key,
    track_nm     varchar(100) not null,
    premiere_dt  date,
    duration_sec integer      not null check (duration_sec > 0),
    genre        varchar(100)
);

create table music.singers
(
    singer_id integer primary key,
    singer_nm varchar(50) not null
);

create table music.playlists
(
    playlist_id   integer primary key,
    user_id       integer not null,
    playlist_nm   varchar(100) default 'новый плейлист',
    playlist_desc varchar(1000),

    foreign key (user_id) references music.users (user_id) on delete cascade
);

create table music.singers_on_track
(
    track_id  integer not null,
    singer_id integer not null,

    constraint pk_singer_track primary key (singer_id, track_id),
    foreign key (singer_id) references music.singers (singer_id) on delete set null,
    foreign key (track_id) references music.tracks (track_id) on delete cascade
);

create table music.songs_in_playlist
(
    playlist_id integer not null,
    track_id    integer not null,

    constraint pk_playlist primary key (playlist_id, track_id),
    foreign key (playlist_id) references music.playlists (playlist_id) on delete cascade,
    foreign key (track_id) references music.tracks (track_id) on delete cascade
);

create table music.devices
(
    device_id integer primary key,
    user_id   integer,
    device_nm varchar[50],

    foreign key (user_id) references music.users (user_id) on delete cascade
);

create table music.track_listening (
    listening_id integer primary key,
    track_id        integer       not null,
    device_id        integer       not null,
    played_from_dttm     timestamp     not null,
    played_to_dttm timestamp not null,
    position_sec    interval,

    foreign key (track_id) references music.tracks(track_id) on delete cascade,
    foreign key (device_id) references music.devices(device_id) on delete cascade
);

-- ВСТАВКА
set datestyle = 'DMY';

insert into music.users
values (1, 'Ростов Николай Ильич', '17.03.1765'),
       (2, 'Болконский Андрей Николаевич,', '25.07.1788'),
       (3, 'Безухов Кирилл Владимирович', '11.11.1711'),
       (4, 'Друбецкая Анна Михайловна', '14.06.1756'),
       (5, 'Денисов Василий Дмитриевич.', '07.09.1783'),
       (6, 'Ростов Николай Ильич', '17.03.1765'),
       (7, 'Ростова Вера Ильинична', '19.01.1768'),
       (8, 'Болконская Марья Николаевна ', '21.04.1770'),
       (9, 'Уваров Фёдор Петрович', '22.11.1745'),
       (10, 'Сперанский Михаил Михайлович', '12.01.1772');

insert into music.tracks
values (1, 'Rum & Coca-Cola', '01.01.1790', 198, 'Jazz'),
       (2, 'Sentimental Journey', '02.01.1791', 241, 'Punk'),
       (3, 'Till The End of Time', '05.04.1792', 207, 'Polka'),
       (4, 'My Dreams Are Getting Better All the Time', '21.01.1790', 176, 'Rock music'),
       (5, 'On the Atchison, Topeka & the Santa Fe', '11.07.1797', 222, 'Rock music'),
       (6, 'It’s Been a Long, Long Time', '11.11.1799', 245, 'Popular music'),
       (7, 'I Can’t Begin to Tell You', '11.09.1792', 194, 'Popular music'),
       (8, 'Ac-cent-tchu-ate the Positive', '01.01.1792', 227, 'Popular music'),
       (9, 'Chickery Chick', '01.01.1791', 172, 'Jazz'),
       (10, 'There! I’ve Said it Again', '01.01.1786', 266, 'Jazz'),
       (11, 'Candy', '01.01.1780', 258, 'Jazz'),
       (12, 'I’m Beginning to See The Light', '01.01.1790', 272, 'Jazz'),
       (13, 'On the Atchison, Topeka & the Santa Fe', '01.01.1779', 256, 'Reggae'),
       (14, 'I’m Beginning to See The Light', '01.01.1795', 246, 'Reggae'),
       (15, 'It’s Been a Long, Long Time', '01.01.1792', 175, 'Pop'),
       (16, 'Nancy, With The Laughing Face', '01.01.1793', 184, 'Classical'),
       (17, 'Caledonia', '01.01.1792', 270, 'Classical'),
       (18, 'I’m Beginning to See The Light', '01.01.1790', 140, 'Classical'),
       (19, 'Ac-cent-tchu-ate the Positive', '01.01.1795', 250, 'Classical'),
       (20, 'Dream', '01.01.1794', 262, 'Easy Listening');

insert into music.singers
values (1, 'The Andrews Sisters'),
       (2, 'Les Brown'),
       (3, 'Perry Como'),
       (4, 'Les Brown'),
       (5, 'Johnny Mercer'),
       (6, 'Harry James'),
       (7, 'Bing Crosby'),
       (8, 'Johnny Mercer'),
       (9, 'Sammy Kaye'),
       (10, 'Vaughn Monroe'),
       (11, 'Johnny Mercer'),   -- Johnny Mercer & Joe Stafford
       (12, 'Duke Ellington'),
       (13, 'Judy Garland'),
       (14, 'Ella Fitzgerald'), --'Ella Fitzgerald & The Ink Spots'
       (15, 'Les Paul'),
       (16, 'Frank Sinatra'),
       (17, 'Louis Jordan'),
       (18, 'Harry James'),
       (19, 'Bing Crosby'),     --'Bing Crosby & The Andrews Sisters'
       (20, 'The Pied Pipers'),
       (21, 'Joe Stafford'),
       (22, 'The Ink Spots');

insert into music.singers_on_track
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (11, 11),
       (11, 21),
       (12, 12),
       (13, 13),
       (14, 14),
       (14, 22),
       (15, 15),
       (16, 16),
       (17, 17),
       (18, 18),
       (19, 19),
       (19, 1),
       (20, 20);


-- ЗАПРОСЫ

-- 1) Прослушивания трека по дням

select t.track_nm                                                           as track_name,
       tl.played_from_dttm,
       count(*) over (partition by t.track_id order by tl.played_from_dttm) as amount_play
from music.track_listening as tl
         inner join music.tracks as t
                    on tl.track_id = t.track_id;


-- 2) Топ прослушиваемых артистов

select count(*),
       t.track_nm
from music.singers_on_track as sot
         inner join music.tracks as t
                    on sot.track_id = t.track_id
         inner join music.track_listening as tl
                    on tl.track_id = t.track_id
group by t.track_nm
order by count(*) asc;


-- 3) Список пользователей, плэйлистов и колличества их прослушивания

select u.user_nm,
       p.playlist_nm,
       count(*) over (partition by p.playlist_id) as amount_on_playlist
from music.playlists as p
         inner join music.songs_in_playlist as sip
                    on p.playlist_id = sip.playlist_id
         inner join music.users as u
                    on u.user_id = p.user_id
         inner join music.tracks as t
                    on t.track_id = sip.track_id
         inner join music.track_listening as tl
                    on tl.track_id = t.track_id;


-- 4) Колличество различных исполнителей для юзера


select u.user_nm,
       count(s.singer_id) amount_different_singers
from music.users as u
         inner join music.playlists as p
                    on u.user_id = p.user_id
         inner join music.songs_in_playlist as sip
                    on sip.playlist_id = p.playlist_id
         inner join music.tracks as t
                    on t.track_id = sip.track_id
         inner join music.singers_on_track as sot
                    on sot.track_id = t.track_id
         inner join music.singers as s
                    on s.singer_id = sot.singer_id
group by u.user_nm;


-- VIEW VIEW VIEW

create schema music_view;

-- VIEW сокрытие

-- user

create view music_view.user_view as
select u.user_id,
       regexp_replace(u.user_nm, '[[:alnum:]]', '*', 'g') as user_name,
       u.birth_dt
from music.users as u;


-- singer


create view music_view.singer_view as
select s.singer_id,
       regexp_replace(s.singer_nm, '[[:alnum:]]', '*', 'g') as singer_name
from music.singers as s;

-- validate_user_data


create view music_view.data_view as
select regexp_replace(data.card_nm, '[[:digit:]]', '*', 'g') as card_number,
       regexp_replace(split_part(data.mail_nm, '@', 1), '[[:alpha:]]', '*', 'g') || '@' ||
       split_part(data.mail_nm, '@', 2)                      as email,
       data.subscr_type
from music.validate_user_data as data;


-- tracks

create view music_view.tracks_view as
select t.track_nm,
       t.premiere_dt,
       t.genre
from music.tracks as t;

-- playlist

create view music_view.playlist_view as
select p.playlist_nm,
       p.playlist_desc
from music.playlists as p;

-- devices

create view music_view.devices_view as
select d.device_nm as device_name
from music.devices as d;



-- VIEW (ADVANCED)

-- 1) user and his songs with playlist

create view music_view.users_and_songs as
select us.user_nm,
       p.playlist_nm,
       t.track_nm
from music.users as us
         inner join music.playlists as p
                    on p.user_id = us.user_id
         inner join music.songs_in_playlist as sip
                    on sip.playlist_id = p.playlist_id
         inner join music.tracks as t
                    on t.track_id = sip.track_id;


-- 2) tracks_listen and device

create view music_view.songs_lsiten_with_singer as
select d.device_nm,
       tl.played_from_dttm,
       tl.played_to_dttm,
       t.track_nm,
       s.singer_id
from music.tracks as t
         inner join music.track_listening as tl
                    on t.track_id = tl.track_id
         inner join music.devices as d
                    on d.device_id = tl.device_id
         inner join music.singers_on_track as sot
                    on sot.track_id = t.track_id
         inner join music.singers as s
                    on s.singer_id = sot.singer_id;

-- 3) User его колличество прослушиваний и последнее

create view music_view.users_plays as
select u.user_nm              as user_name,
       count(*)               as amount_songs,
       max(tl.played_to_dttm) as last_play
from music.users as u
         inner join music.devices as d
                    on u.user_id = d.user_id
         inner join music.track_listening as tl
                    on tl.device_id = d.device_id
group by u.user_nm
order by amount_songs asc;


-- при добавлении новой версии подписки пользователя устанавливает valid_to для старой и вставляет новую

create or replace function music.update_validate_data_func() returns trigger as
$$
begin
    if (new.valid_from_dttm is null) then
        new.valid_from_dttm = now();
    end if;

    update music.validate_user_data
    set valid_to_dttm = new.valid_from_dttm
    where user_id = new.user_id
      and valid_to_dttm > new.valid_from_dttm;

    return new;

end;
$$ language plpgsql;


create trigger update_valida_data
    before insert
    on music.validate_user_data
    for each row
execute procedure music.update_validate_data_func();

-- при добавлении нового трека played_to_dttm старых записей меняется


create or replace function music.update_track_listening_func() returns trigger as
$$
begin

     if (new.position_sec) then
        new.position_sec = interval '00:00:00';
    end if;

    update music.track_listening
    set played_to_dttm = new.played_from_dttm
    where device_id = new.device_id
      and played_to_dttm > new.played_from_dttm;

    return new;


end;

$$ language plpgsql;

create trigger update_track_listening
    before insert
    on music.track_listening
    for each row

execute procedure music.update_track_listening_func();

-- добавляет пользователю с id user_to_add_id плейлист состоящий из песен исполнителя singer_to_add_id

create or replace procedure music.create_playlist_from_singer(singer_to_add_id int, user_to_add_id int)
as
$$
declare
    current_track_id int;
    new_playlist_id int;
    singer_name text;
    singer_cnt int := 0;
    user_cnt int := 0;
begin
    execute 'select singer_nm from music.singers where singer_id = $1'
        into singer_name using singer_to_add_id;

    execute 'select count(user_id) from music.users' into user_cnt;

    if user_cnt = 0 then
        raise exception 'user does not exists';
    end if;

    execute 'select coalesce(max(playlist_id), 0) from music.playlists' into new_playlist_id;
    new_playlist_id := new_playlist_id + 1;
    insert into music.playlists values (new_playlist_id, user_to_add_id, 'All of ' || singer_name,
                                        'Плейлист содержит все песни исполнителя ' || singer_name);
    for current_track_id in select track_id from music.singers_on_track where singer_id = singer_to_add_id
        loop
            insert into music.songs_in_playlist values(new_playlist_id, current_track_id);
        end loop;
end;
$$
    language plpgsql;

call music.create_playlist_from_singer(6, 1);