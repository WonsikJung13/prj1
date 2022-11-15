package com.study.prj1.mapper.member;


import com.study.prj1.domain.member.MemberDto;

import java.util.List;

public interface MemberMapper {

    int insert(MemberDto member);

    List<MemberDto> selectAll();

    MemberDto selectOne(String id);

    int update(MemberDto member);

    int remove(String id);

    MemberDto getEmail(String email);
}
