package com.study.prj1.security;

import com.study.prj1.domain.board.BoardDto;
import com.study.prj1.mapper.board.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BoardSecurity {

    @Autowired
    private BoardMapper mapper;

    public boolean checkWriter(String username, int boardId) {
        BoardDto board = mapper.select(boardId);

        return board.getWriter().equals(username);
    }
}
