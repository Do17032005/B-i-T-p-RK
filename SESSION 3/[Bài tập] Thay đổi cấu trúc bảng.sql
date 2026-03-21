alter table library.books add column genre  varchar(50);

alter table library.books rename column available to is_available;

alter table library.members drop column email;


drop table sales.orderdetails;