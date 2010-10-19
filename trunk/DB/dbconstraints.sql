/****** Object:  StoredProcedure [dbo].[updateChannel]    Script Date: 10/19/2010 09:22:21 ******/
-- =============================================
-- Author:		billythekids
-- Create date: 10/17/2010
-- Description:	This fnction will update all total clip in channel
-- =============================================
CREATE PROCEDURE [dbo].[updateChannel]
	@cid int
AS
BEGIN
	update mc_channel set total_clips = (select COUNT(id) from mc_clips where chanel_id=@cid and approve=1) where cid=@cid
END

/****** Object:  StoredProcedure [dbo].[removeClips]    Script Date: 10/19/2010 09:22:21 ******/
-- =============================================
-- Author:		billythekids
-- Create date: 10/16/2010
-- Description:	remove a given clip id and all of his constraints return a image and path to manual delete files
-- =============================================
CREATE PROCEDURE [dbo].[removeClips]
	-- Add the parameters for the stored procedure here
	@ids int	
AS
select path, image from mc_clips where id = @ids
BEGIN	
	delete from mc_report where clip_id = @ids;
	delete from mc_comments where clip_id = @ids;
	delete from mc_clip_rate where clip_id = @ids;	
	delete from mc_clips where id = @ids;		
END

/****** Object:  StoredProcedure [dbo].[removeChannel]    Script Date: 10/19/2010 09:22:21 ******/
-- =============================================
-- Author:		billythekids
-- Create date: 10/16/2010
-- Description:	This function will remove all clip, clip_rate; clip_comments and channel
-- =============================================
CREATE PROCEDURE [dbo].[removeChannel]
	@cid int
AS
BEGIN
	delete from mc_report where clip_id in (select id from mc_clips where chanel_id = @cid);
	delete from mc_comments where clip_id in (select id from mc_clips where chanel_id = @cid);
	delete from mc_clip_rate where clip_id in (select id from mc_clips where chanel_id = @cid);
	delete from mc_clips where chanel_id=@cid;	
	delete from mc_channel where cid = @cid;	
	return 1
END


