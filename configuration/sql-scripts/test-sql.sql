create table public.license (
  id          serial4 not null,
  "key"       text null,
  constraint  license_pk primary key (id)
);

alter table public.license owner to abuba;

INSERT INTO license (key) VALUES ('License by NGRSoftlab with love');
