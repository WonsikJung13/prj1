package com.study.prj1.security;

import com.study.prj1.domain.board.ReplyDto;
import com.study.prj1.mapper.board.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ReplySecurity {

    @Autowired
    private ReplyMapper mapper;

    public boolean checkWriter(String userName, int id) {

        ReplyDto reply = mapper.selectById(id);

        return reply.getWriter().equals(userName);
    }
}
