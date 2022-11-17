package com.study.prj1.domain.member;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MemberDto {
    private String id;
    private String nickName;
    private String email;
    private String password;

    private LocalDateTime inserted;

    public String getRegDate() {
        LocalDateTime now = LocalDateTime.now();

        return "inserted.toLocalDate().toString()";
    }
}
