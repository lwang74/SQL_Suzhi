use XX2012
GO

declare @ban_ji varchar(100)
declare @xh_from varchar(100)
declare @xh_to varchar(100)

Set @ban_ji='c11����' --��༶����
Set @xh_from='j110406048' --�ʼѧ��
Set @xh_to='j110406048' --�����ѧ��

declare @bjxh as int
select @bjxh=bjxh from JKBANJI b
	where bjmc=@ban_ji

if @bjxh is not null
begin
	delete JKBAN_XUESHENG
		where xh between @xh_from and @xh_to

	insert into JKBAN_XUESHENG
		select @bjxh, x.xh from JKXUESHENG x
		where x.xh between @xh_from and @xh_to

	Select b.bjmc, COUNT(*) Count 
		from JKBANJI b
		join JKBAN_XUESHENG bx on bx.bjxh=b.bjxh
		group by b.bjmc
		order by b.bjmc

end
else
	print '�༶���� ����ȷ��'
GO


/*	
select * from JKBANJI b
select * from JKXUESHENG
select * from JKBAN_XUESHENG
*/