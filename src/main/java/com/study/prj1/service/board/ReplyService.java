package com.study.prj1.service.board;


import com.study.prj1.domain.board.ReplyDto;
import com.study.prj1.mapper.board.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReplyService {

    @Autowired
    private ReplyMapper mapper;

    public int addReply(ReplyDto reply) {
        return mapper.insert(reply);
    }

    public List<ReplyDto> listReplyByBoardId(int boardId) {
        return mapper.selectReplyByBoardId(boardId);
    }

    public int removeById(int id) {
        return mapper.deleteById(id);
    }

    public ReplyDto getById(int id) {
        // TODO Auto-generated method stub
        return mapper.selectById(id);
    }

    public int modify(ReplyDto reply) {
        // TODO Auto-generated method stub
        return mapper.update(reply);
    }

}
