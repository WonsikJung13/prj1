package com.study.prj1.domain.member;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class MemberDto {
    private String id;
    private String nickName;
    private String email;
    private String password;

    private LocalDateTime inserted;
}
