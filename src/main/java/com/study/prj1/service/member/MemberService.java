package com.study.prj1.service.member;


import com.study.prj1.domain.member.MemberDto;
import com.study.prj1.mapper.member.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberService {
    @Autowired
    private MemberMapper mapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public int insert(MemberDto member) {

        String pw = member.getPassword();

        member.setPassword(passwordEncoder.encode(pw));

        return mapper.insert(member);
    }

    public List<MemberDto> list() {
        // TODO Auto-generated method stub
        return mapper.selectAll();
    }

    public MemberDto getById(String id) {
        // TODO Auto-generated method stub
        return mapper.selectById(id);
    }

    public int modify(MemberDto member) {
        int cnt = 0;

        try {
            if (member.getPassword() != null) {
                String encodedPw = passwordEncoder.encode(member.getPassword());
                member.setPassword(encodedPw);
            }

            return mapper.update(member);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cnt;
    }

    public int remove(String id) {
        return mapper.deleteById(id);
    }

    public MemberDto getByEmail(String email) {
        // TODO Auto-generated method stub
        return mapper.selectByEmail(email);
    }

    public MemberDto getByNickName(String nickName) {
        // TODO Auto-generated method stub
        return mapper.selectByNickName(nickName);
    }
}
