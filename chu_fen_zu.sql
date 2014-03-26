USE XX2012
GO

declare @banji varchar(20)
declare @m nvarchar(20)
declare @f nvarchar(20)
Set @banji = 'c11%' --用于初中，性别：男1女2； 高中则男1女0
Set @m = '男组'
Set @f = '女组'

--建立男生组 如班名'c11一班' =>'c11一班男组'
INSERT INTO [dbo].[JKZU]
           ([bjxh]
           ,[zmc]
           ,[zpx])
	SELECT b.bjxh, b.bjmc+@m, 1 
		FROM dbo.JKBANJI b
		Left join dbo.JKZU z on z.bjxh=b.bjxh and z.zmc=b.bjmc+@m and z.zpx=1
		WHERE bjmc LIKE @banji and z.bjxh is null

--建立女生组 如班名'c11一班' =>'c11一班女组'
INSERT INTO [dbo].[JKZU]
           ([bjxh]
           ,[zmc]
           ,[zpx])
	SELECT b.bjxh, b.bjmc+@f, 2 
		FROM dbo.JKBANJI b
		Left join dbo.JKZU z on z.bjxh=b.bjxh and z.zmc=b.bjmc+@f and z.zpx=2
		WHERE bjmc LIKE @banji and z.bjxh is null

--将组内学号最小的设为组长
Update z Set xh = a.xh
	from JKZU z
	Join (
		Select b.bjmc, x.xb, MIN(x.xh) xh	
			from JKXUESHENG	x
			join JKBAN_XUESHENG bx on bx.xh=x.xh
			Join JKBANJI b on b.bjxh=bx.bjxh
			Where b.bjmc like @banji
			Group by b.bjmc, x.xb) a on a.bjmc+case a.xb when 1 then @m else @f end=z.zmc and a.xb=z.zpx

--删除旧学生与组对应关系
Delete xz
	from JKXUESHENG_ZU xz
	join ( 
		Select distinct z.zxh
			from JKZU z 
			join JKBANJI b on b.bjmc+@m=z.zmc or b.bjmc+@f=z.zmc
			Where b.bjmc like @banji) a on a.zxh =xz.zxh

--建立学生与组对应
Insert into JKXUESHENG_ZU (zxh, xh)
	select z.zxh, x.xh
		from JKXUESHENG x
		Join JKBAN_XUESHENG bx on bx.xh=x.xh
		Join JKBANJI b on b.bjxh=bx.bjxh
		Join JKZU z on (z.zmc=b.bjmc+@m or z.zmc=b.bjmc+@f) and z.zpx=case x.xb when 2 then 2 else 1 end 
		Where b.bjmc like @banji 