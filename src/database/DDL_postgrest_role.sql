create schema lts;

create role web_anon nologin;

grant usage on schema lts to web_anon;
grant select on lts.todos to web_anon;

create role authenticator noinherit login password 'password';
grant web_anon to authenticator;