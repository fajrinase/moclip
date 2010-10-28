/****** Object:  Table [dbo].[mc_channel]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_channel](
	[cid] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[total_clips] [int] NOT NULL,
 CONSTRAINT [PK_mc_chanel] PRIMARY KEY CLUSTERED 
(
	[cid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SET IDENTITY_INSERT [dbo].[mc_channel] ON
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (1, N'Arts', 1)
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (2, N'Movies & TV', 3)
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (3, N'Sports', 1)
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (4, N'Tech & Science', 1)
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (5, N'Funny', 1)
INSERT [dbo].[mc_channel] ([cid], [title], [total_clips]) VALUES (6, N'Clips', 6)
SET IDENTITY_INSERT [dbo].[mc_channel] OFF
/****** Object:  Table [dbo].[mc_users]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_users](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](32) NOT NULL,
	[password] [nvarchar](32) NOT NULL,
	[fullname] [nvarchar](32) NULL,
	[address] [nvarchar](64) NULL,
	[phone] [nvarchar](20) NULL,
	[mobile] [nvarchar](20) NULL,
	[email] [nvarchar](32) NULL,
	[sex] [tinyint] NULL,
	[date_joined] [datetime] NULL,
	[question] [nvarchar](200) NULL,
	[answer] [nvarchar](100) NULL,
	[allow_acp] [tinyint] NULL,
 CONSTRAINT [PK_mc_users] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_mc_users] ON [dbo].[mc_users] 
(
	[fullname] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_mc_users_1] ON [dbo].[mc_users] 
(
	[username] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Full search for username' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mc_users', @level2type=N'CONSTRAINT',@level2name=N'PK_mc_users'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'index fullname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mc_users', @level2type=N'INDEX',@level2name=N'IX_mc_users'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'index username' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mc_users', @level2type=N'INDEX',@level2name=N'IX_mc_users_1'

SET IDENTITY_INSERT [dbo].[mc_users] ON
INSERT [dbo].[mc_users] ([uid], [username], [password], [fullname], [address], [phone], [mobile], [email], [sex], [date_joined], [question], [answer], [allow_acp]) VALUES (1, N'admin                           ', N'123456                          ', N'Account Test                    ', N'                                                                ', N'                    ', N'                    ', N'billythekidsde@gmail.com        ', 1, NULL, N'What was your childhood nickname?                                                                                                                                                                       ', N'i dont know                                                                                         ', 1)
INSERT [dbo].[mc_users] ([uid], [username], [password], [fullname], [address], [phone], [mobile], [email], [sex], [date_joined], [question], [answer], [allow_acp]) VALUES (6, N'test                            ', N'asdf                            ', N'Hello World                     ', N'                                                                ', N'                    ', N'                    ', N'test@moclip.com                 ', 1, CAST(0x00009E0E00DBF654 AS DateTime), N'In what city or town did your mother and father meet?                                                                                                                                                   ', N'i dont know                                                                                         ', 0)
SET IDENTITY_INSERT [dbo].[mc_users] OFF
/****** Object:  Table [dbo].[mc_clips]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_clips](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[description] [nvarchar](max) NULL,
	[chanel_id] [int] NOT NULL,
	[path] [nvarchar](200) NOT NULL,
	[submiter] [int] NOT NULL,
	[date_added] [datetime] NOT NULL,
	[last_modified] [datetime] NOT NULL,
	[image] [nvarchar](200) NULL,
	[hits] [bigint] NULL,
	[private] [tinyint] NULL,
	[approve] [tinyint] NOT NULL,
 CONSTRAINT [PK_mc_clips] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Full search for title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mc_clips', @level2type=N'CONSTRAINT',@level2name=N'PK_mc_clips'

SET IDENTITY_INSERT [dbo].[mc_clips] ON
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (3, N'Demo Clip', N'The Copyright Tips page and the Community Guidelines can help you determine whether your video infringes someone else&#39;s copyright By clicking &quot;Share Clip&quot;, you are representing that this video does not violate Our&#39;s Terms of Use and that you own all copyrights in this video or have authorization to upload i', 4, N'videoplayback.flv', 6, CAST(0x00009E0E00000000 AS DateTime), CAST(0x00009E0E00000000 AS DateTime), N'1286997696Koala.jpg', 339, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (111, N'Unchained Melody', N'Baby sorry i love you', 2, N'1287173964Gareth-Gates---unchained-melody.flv', 1, CAST(0x00009E1000000000 AS DateTime), CAST(0x00009E1000000000 AS DateTime), N'1287173964Lighthouse.jpg', 5, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (112, N'Nobody', N'Performance by Wonder Girls', 6, N'1287328110YouTube - Wonder Girls NOBODY US Debut Single HD MV.flv', 1, CAST(0x00009E1200000000 AS DateTime), CAST(0x00009E1200000000 AS DateTime), N'1287328110Wonder_Girls_23072009075741.jpg', 17, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (113, N'Funny Football', N'Funny Football', 5, N'1287354253YouTube - Funny Football.flv', 1, CAST(0x00009E1200000000 AS DateTime), CAST(0x00009E1200000000 AS DateTime), N'1287354253Funny_wallpapers_Fight_for_a_ball___Football_009196_.jpg', 4, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (121, N'Stairway to Heaven', N'Stairway to Heaven', 6, N'1287411533YouTube - stairway to heaven ( from this moment).flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287411533Stairway_To_Heaven_100026.jpg', 2, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (122, N'Because I love You', N'Because I love You', 2, N'1287411692YouTube-Because I Love You-.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'12874116921230525249150_2.jpg', 7, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (123, N'Sand Art', N'Sand Art', 1, N'1287411769YouTube - Sand art.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287411769sand-art.jpg', 3, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (124, N'Because I am A Girl', N'Kiss', 6, N'1287411894YouTube - Because I am A Girl -- Kiss.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287411894hqdefault.jpg', 6, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (125, N'Trouble is a friend', N'Trouble is a friend - Lenka', 6, N'1287411988videoplayback.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287411988Lenka-N2-syd1266997919.jpg', 1, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (126, N'Full House', N'Full House', 6, N'1287412070YouTube - OST Full House.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'128741207065011744486276233704.jpg', 1, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (127, N'A Moment to Remember', N'A Moment to Remember', 2, N'1287412126YouTube - MV - A Moment to Remember(korean movie).flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287412126a_moment_to_remember1.jpg', 2, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (128, N'Never say odbye', N'My Girl OST- Never Say odbye', 6, N'1287412275YouTube - My Girl OST- Never Say odbye.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'12874122750054653754.jpg', 2, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (129, N' Nuri Sahin vs. Lukas Podolsk', N' Nuri Sahin vs. Lukas Podolsk', 3, N'1287412444YouTube - Nuri Sahin vs. Lukas Podolski.flv', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'1287412444Lukas-Podolski-wallpaper-24-1024x768.jpg', 0, 0, 1)
INSERT [dbo].[mc_clips] ([id], [title], [description], [chanel_id], [path], [submiter], [date_added], [last_modified], [image], [hits], [private], [approve]) VALUES (130, N'Next Plane Home', N'Next Plane Home', 6, N'1287412953Next Plane Home.mp4', 1, CAST(0x00009E1300000000 AS DateTime), CAST(0x00009E1300000000 AS DateTime), N'12874129532881079179_904bd33133.jpg', 1, 0, 1)
SET IDENTITY_INSERT [dbo].[mc_clips] OFF
/****** Object:  Table [dbo].[mc_suggestion]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_suggestion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[date_added] [datetime] NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[content] [ntext] NOT NULL,
 CONSTRAINT [PK_mc_suggestion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[mc_report]    Script Date: 10/19/2010 09:22:21 ******/

CREATE TABLE [dbo].[mc_report](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[clip_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[comment] [nvarchar](500) NULL,
	[report_date] [datetime] NOT NULL,
 CONSTRAINT [PK_mc_report] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[clip_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[mc_news](
	[nid] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](200) NULL,
	[content] [ntext] NULL,
	[date_added] [datetime] NULL,
	[submiter] [int] NULL,
	[image] [nvarchar](200) NULL,
	[description] [nvarchar](500) NULL,
 CONSTRAINT [PK_mc_news] PRIMARY KEY CLUSTERED 
(
	[nid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


/****** Object:  Table [dbo].[mc_comments]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_comments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[clip_id] [int] NULL,
	[user_id] [int] NULL,
	[title] [nvarchar](100) NULL,
	[comment] [ntext] NULL,
	[approve] [tinyint] NOT NULL,
	[date_added] [datetime] NULL,
 CONSTRAINT [PK_mc_comments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET IDENTITY_INSERT [dbo].[mc_comments] ON
INSERT [dbo].[mc_comments] ([id], [clip_id], [user_id], [title], [comment], [approve], [date_added]) VALUES (13, 3, 6, N'hello                                                                                               ', N'im very tired now', 1, CAST(0x00009E110122F276 AS DateTime))
INSERT [dbo].[mc_comments] ([id], [clip_id], [user_id], [title], [comment], [approve], [date_added]) VALUES (19, 112, 1, N'aaaaaaaaa                                                                                           ', N'hay qua di', 1, CAST(0x00009E1200FA7CA7 AS DateTime))
SET IDENTITY_INSERT [dbo].[mc_comments] OFF
/****** Object:  Table [dbo].[mc_clip_rate]    Script Date: 10/19/2010 09:22:21 ******/
CREATE TABLE [dbo].[mc_clip_rate](
	[clip_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rate] [int] NOT NULL,
 CONSTRAINT [PK_mc_clip_rate] PRIMARY KEY CLUSTERED 
(
	[clip_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT [dbo].[mc_clip_rate] ([clip_id], [user_id], [rate]) VALUES (3, 1, 2)
INSERT [dbo].[mc_clip_rate] ([clip_id], [user_id], [rate]) VALUES (3, 6, 5)
INSERT [dbo].[mc_clip_rate] ([clip_id], [user_id], [rate]) VALUES (112, 1, 1)

/****** Object:  Default [DF_mc_chanel_total_clips]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_channel] ADD  CONSTRAINT [DF_mc_chanel_total_clips]  DEFAULT ((0)) FOR [total_clips]

/****** Object:  Default [DF_mc_users_date_joined]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_users] ADD  CONSTRAINT [DF_mc_users_date_joined]  DEFAULT (getdate()) FOR [date_joined]

/****** Object:  Default [DF_mc_users_allow_acp]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_users] ADD  CONSTRAINT [DF_mc_users_allow_acp]  DEFAULT ((0)) FOR [allow_acp]

/****** Object:  Default [DF_mc_clips_date_added]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips] ADD  CONSTRAINT [DF_mc_clips_date_added]  DEFAULT (getdate()) FOR [date_added]

/****** Object:  Default [DF_mc_clips_last_modified]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips] ADD  CONSTRAINT [DF_mc_clips_last_modified]  DEFAULT (getdate()) FOR [last_modified]

/****** Object:  Default [DF_mc_clips_hits]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips] ADD  CONSTRAINT [DF_mc_clips_hits]  DEFAULT ((0)) FOR [hits]

/****** Object:  Default [DF_mc_clips_private]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips] ADD  CONSTRAINT [DF_mc_clips_private]  DEFAULT ((0)) FOR [private]

/****** Object:  Default [DF_mc_clips_approve]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips] ADD  CONSTRAINT [DF_mc_clips_approve]  DEFAULT ((0)) FOR [approve]

/****** Object:  Default [DF_mc_report_report_date]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_report] ADD  CONSTRAINT [DF_mc_report_report_date]  DEFAULT (getdate()) FOR [report_date]

/****** Object:  Default [DF_mc_comments_approve]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_comments] ADD  CONSTRAINT [DF_mc_comments_approve]  DEFAULT ((0)) FOR [approve]

/****** Object:  Default [DF_mc_comments_date_added]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_comments] ADD  CONSTRAINT [DF_mc_comments_date_added]  DEFAULT (getdate()) FOR [date_added]

/****** Object:  Default [DF_mc_clip_rate_rate]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clip_rate] ADD  CONSTRAINT [DF_mc_clip_rate_rate]  DEFAULT ((0)) FOR [rate]

/****** Object:  ForeignKey [FK_mc_clips_mc_chanel]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clips]  WITH CHECK ADD  CONSTRAINT [FK_mc_clips_mc_chanel] FOREIGN KEY([chanel_id])
REFERENCES [dbo].[mc_channel] ([cid])

ALTER TABLE [dbo].[mc_clips] CHECK CONSTRAINT [FK_mc_clips_mc_chanel]

/****** Object:  ForeignKey [FK_mc_suggestion_mc_users]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_suggestion]  WITH CHECK ADD  CONSTRAINT [FK_mc_suggestion_mc_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[mc_users] ([uid])

ALTER TABLE [dbo].[mc_suggestion] CHECK CONSTRAINT [FK_mc_suggestion_mc_users]

/****** Object:  ForeignKey [FK_mc_report_mc_clips]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_report]  WITH CHECK ADD  CONSTRAINT [FK_mc_report_mc_clips] FOREIGN KEY([clip_id])
REFERENCES [dbo].[mc_clips] ([id])

ALTER TABLE [dbo].[mc_report] CHECK CONSTRAINT [FK_mc_report_mc_clips]

/****** Object:  ForeignKey [FK_mc_report_mc_users]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_report]  WITH CHECK ADD  CONSTRAINT [FK_mc_report_mc_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[mc_users] ([uid])

ALTER TABLE [dbo].[mc_report] CHECK CONSTRAINT [FK_mc_report_mc_users]

/****** Object:  ForeignKey [FK_mc_comments_mc_clips]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_comments]  WITH CHECK ADD  CONSTRAINT [FK_mc_comments_mc_clips] FOREIGN KEY([clip_id])
REFERENCES [dbo].[mc_clips] ([id])

ALTER TABLE [dbo].[mc_comments] CHECK CONSTRAINT [FK_mc_comments_mc_clips]

/****** Object:  ForeignKey [FK_mc_comments_mc_users]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_comments]  WITH CHECK ADD  CONSTRAINT [FK_mc_comments_mc_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[mc_users] ([uid])

ALTER TABLE [dbo].[mc_comments] CHECK CONSTRAINT [FK_mc_comments_mc_users]

/****** Object:  ForeignKey [FK_mc_clip_rate_mc_clips]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clip_rate]  WITH CHECK ADD  CONSTRAINT [FK_mc_clip_rate_mc_clips] FOREIGN KEY([clip_id])
REFERENCES [dbo].[mc_clips] ([id])

ALTER TABLE [dbo].[mc_clip_rate] CHECK CONSTRAINT [FK_mc_clip_rate_mc_clips]

/****** Object:  ForeignKey [FK_mc_clip_rate_mc_users]    Script Date: 10/19/2010 09:22:21 ******/
ALTER TABLE [dbo].[mc_clip_rate]  WITH CHECK ADD  CONSTRAINT [FK_mc_clip_rate_mc_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[mc_users] ([uid])

ALTER TABLE [dbo].[mc_clip_rate] CHECK CONSTRAINT [FK_mc_clip_rate_mc_users]
