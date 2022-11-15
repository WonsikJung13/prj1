package com.study.prj1.service.member;


import com.study.prj1.domain.member.MemberDto;
import com.study.prj1.mapper.member.MemberMapper;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberService {

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    public int insert(MemberDto member) {

        return mapper.insert(member);
    }

    public List<MemberDto> list() {
        return mapper.selectAll();
    }

    public MemberDto select(String id) {
        return mapper.selectOne(id);
    }

    public int modify(MemberDto member) {
        int cnt = 0;

        try {
            return mapper.update(member);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cnt;
    }

    public int remove(String id) {
        return mapper.remove(id);
    }

    public MemberDto getEmail(String email) {
        return mapper.getEmail(email);
    }
}
