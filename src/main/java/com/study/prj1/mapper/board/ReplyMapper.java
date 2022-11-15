package com.study.prj1.mapper.board;


import com.study.prj1.domain.board.ReplyDto;

import java.util.List;

public interface ReplyMapper {

    int insert(ReplyDto reply);

    List<ReplyDto> selectReplyByBoardId(int boardId);

    int deleteById(int id);

    ReplyDto selectById(int id);

    int update(ReplyDto reply);

    int deleteByBoardId(int id);

}
