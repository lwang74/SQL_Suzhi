/*
c11一班
c11二班
c11三班
c11四班
c11五班
c11六班
c11七班
c11八班
c11九班
c11十班
*/ 
Declare @Student as varchar(100)
Declare @fromClass as varchar(100)
Declare @toClass as varchar(100)
Declare @toClassXh as int
set @fromClass='c11九班'

set @Student='张万英'
set @toClass='c11一班'

select @toClassXh=b.bjxh
	from JKBANJI b 
	where bjmc=@toClass

update bx set bjxh=@toClassXh
	from JKBAN_XUESHENG bx
	join JKXUESHENG x on x.xh=bx.xh
	join JKBANJI b on b.bjxh=bx.bjxh
	where x.xm=@Student and b.bjmc=@fromClass

select *
	from JKBAN_XUESHENG bx 
	join JKBANJI b on b.bjxh=bx.bjxh
	join JKXUESHENG x on x.xh=bx.xh
	where b.bjmc='c11九班'


