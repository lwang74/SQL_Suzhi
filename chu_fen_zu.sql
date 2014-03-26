USE XX2012
GO

declare @banji varchar(20)
declare @m nvarchar(20)
declare @f nvarchar(20)
Set @banji = 'c11%' --���ڳ��У��Ա���1Ů2�� ��������1Ů0
Set @m = '����'
Set @f = 'Ů��'

--���������� �����'c11һ��' =>'c11һ������'
INSERT INTO [dbo].[JKZU]
           ([bjxh]
           ,[zmc]
           ,[zpx])
	SELECT b.bjxh, b.bjmc+@m, 1 
		FROM dbo.JKBANJI b
		Left join dbo.JKZU z on z.bjxh=b.bjxh and z.zmc=b.bjmc+@m and z.zpx=1
		WHERE bjmc LIKE @banji and z.bjxh is null

--����Ů���� �����'c11һ��' =>'c11һ��Ů��'
INSERT INTO [dbo].[JKZU]
           ([bjxh]
           ,[zmc]
           ,[zpx])
	SELECT b.bjxh, b.bjmc+@f, 2 
		FROM dbo.JKBANJI b
		Left join dbo.JKZU z on z.bjxh=b.bjxh and z.zmc=b.bjmc+@f and z.zpx=2
		WHERE bjmc LIKE @banji and z.bjxh is null

--������ѧ����С����Ϊ�鳤
Update z Set xh = a.xh
	from JKZU z
	Join (
		Select b.bjmc, x.xb, MIN(x.xh) xh	
			from JKXUESHENG	x
			join JKBAN_XUESHENG bx on bx.xh=x.xh
			Join JKBANJI b on b.bjxh=bx.bjxh
			Where b.bjmc like @banji
			Group by b.bjmc, x.xb) a on a.bjmc+case a.xb when 1 then @m else @f end=z.zmc and a.xb=z.zpx

--ɾ����ѧ�������Ӧ��ϵ
Delete xz
	from JKXUESHENG_ZU xz
	join ( 
		Select distinct z.zxh
			from JKZU z 
			join JKBANJI b on b.bjmc+@m=z.zmc or b.bjmc+@f=z.zmc
			Where b.bjmc like @banji) a on a.zxh =xz.zxh

--����ѧ�������Ӧ
Insert into JKXUESHENG_ZU (zxh, xh)
	select z.zxh, x.xh
		from JKXUESHENG x
		Join JKBAN_XUESHENG bx on bx.xh=x.xh
		Join JKBANJI b on b.bjxh=bx.bjxh
		Join JKZU z on (z.zmc=b.bjmc+@m or z.zmc=b.bjmc+@f) and z.zpx=case x.xb when 2 then 2 else 1 end 
		Where b.bjmc like @banji 