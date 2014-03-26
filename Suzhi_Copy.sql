/*
select * from
	dbo.JKSUZHI
	where xh='j110406001'
	order by nf, wdxh
*/
/*
insert into dbo.JKSUZHI
select s3.xh, s3.wdxh, 1, s3.wzpj, s3.djpj, s3.jsxh, s3.pjr, GETDATE(), newid()	
--select * 
	from dbo.JKSUZHI s3
	left join dbo.JKSUZHI s1 on s1.xh=s3.xh and s1.wdxh=s3.wdxh and s1.jsxh=s3.jsxh and s1.nf=1
	where s3.nf=3 and s1.xh is null
		and s3.xh like 'j%'
*/
/*		
select top 1000 * from
	dbo.JKXUESHENG
select top 1000 * from
	dbo.JKBANJI
	
select COUNT(*)
	from dbo.JKXUESHENG
	where xh like 'j%'
*/	

--拷贝某班的一个年份的素质评价至另外一个年份
declare @fromYear int
declare @toYear int
declare @class varchar(100)
set @fromYear = 2
set @toYear = 3
set @class = 'c11十班'

insert into dbo.JKSUZHI
select s2.xh, s2.wdxh, @toYear, s2.wzpj, s2.djpj, s2.jsxh, s2.pjr, GETDATE(), newid()	
--select s2.*
	from JKXUESHENG x
	join dbo.JKSUZHI s2 on s2.xh=x.xh and s2.nf=@fromYear
	left join dbo.JKSUZHI s3 on s3.xh=s2.xh and s3.wdxh=s2.wdxh and s3.jsxh=s2.jsxh and s3.nf=@toYear
	join JKBAN_XUESHENG bx on bx.xh =x.xh
	join JKBANJI b on b.bjxh=bx.bjxh
	where b.bjmc=@class and s3.xh is null

select s2.*
	from JKXUESHENG x
	join dbo.JKSUZHI s2 on s2.xh=x.xh 
	join JKBAN_XUESHENG bx on bx.xh =x.xh
	join JKBANJI b on b.bjxh=bx.bjxh
	where b.bjmc=@class
	order by b.bjmc, x.xh, s2.nf, s2.wdxh