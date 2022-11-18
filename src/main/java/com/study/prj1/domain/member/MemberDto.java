package com.study.prj1.domain.member;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class MemberDto {
    private String id;
    private String nickName;
    private String email;
    private String password;

    private LocalDateTime inserted;

    private List<String> auth;

    public String getDate() {
        String result = "";

        result = inserted.toLocalDate().toString();

        return result;
    }

    public String getDatetime() {
        String result = "";

        result = ((inserted.toLocalDate().toString()) + " " + (inserted.toLocalTime().toString()));

        return result;
    }
}
