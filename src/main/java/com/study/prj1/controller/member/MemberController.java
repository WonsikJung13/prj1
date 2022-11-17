package com.study.prj1.controller.member;


import com.study.prj1.domain.member.MemberDto;
import com.study.prj1.service.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("member")
public class MemberController {
    @Autowired
    private MemberService service;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("login")
    public void login() {

    }

    @GetMapping("existNickName/{nickName}")
    @ResponseBody
    public Map<String, Object> existNickName(@PathVariable String nickName) {
        Map<String, Object> map = new HashMap<>();

        MemberDto member = service.getByNickName(nickName);

        if (member == null) {
            map.put("status", "not exist");
            map.put("message", "사용가능한 별명입니다.");
        } else {
            map.put("status", "exist");
            map.put("message", "이미 존재하는 별명입니다.");
        }

        return map;
    }

    @PostMapping("existEmail")
    @ResponseBody
    public Map<String, Object> existEmail(@RequestBody Map<String, String> req) {

        Map<String, Object> map = new HashMap<>();

        MemberDto member = service.getByEmail(req.get("email"));

        if (member == null) {
            map.put("status", "not exist");
            map.put("message", "사용가능한 이메일입니다.");
        } else {
            map.put("status", "exist");
            map.put("message", "이미 존재하는 이메일입니다.");
        }

        return map;
    }

    @GetMapping("existId/{id}")
    @ResponseBody
    public Map<String, Object> existId(@PathVariable String id) {
        Map<String, Object> map = new HashMap<>();

        MemberDto member = service.getById(id);

        if (member == null) {
            map.put("status", "not exist");
            map.put("message", "사용가능한 아이디입니다.");
        } else {
            map.put("status", "exist");
            map.put("message", "이미 존재하는 아이디입니다.");
        }

        return map;
    }

    @GetMapping("signup")
    public void signup() {

    }

    @PostMapping("signup")
    public String signup(MemberDto member, RedirectAttributes rttr) {
        System.out.println(member);

        int cnt = service.insert(member);

        // 가입 잘되면
        rttr.addFlashAttribute("message", "회원가입 되었습니다.");
        return "redirect:/board/list";
    }

    @GetMapping("list")
    public void list(Model model) {
        model.addAttribute("memberList", service.list());
    }

    @GetMapping({ "info", "modify" })
    public void info(String id, Model model) {

        model.addAttribute("member", service.getById(id));
    }

    @PostMapping("modify")
    public String modify(MemberDto member, String oldPassword, RedirectAttributes rttr) {
        MemberDto oldmember = service.getById(member.getId());

        rttr.addAttribute("id", member.getId());
        boolean passwordMatch = passwordEncoder.matches(oldPassword, oldmember.getPassword());
        if (passwordMatch) {
            // 기존 암호가 맞으면 회원 정보 수정
            int cnt = service.modify(member);

            if (cnt == 1) {
                rttr.addFlashAttribute("message", "회원 정보가 수정되었습니다.");
                return "redirect:/member/info";
            } else {
                rttr.addFlashAttribute("message", "회원 정보가 수정되지 않았습니다.");
                return "redirect:/member/modify";
            }
        } else {
            rttr.addFlashAttribute("message", "암호가 일치하지 않습니다.");
            return "redirect:/member/modify";
        }

    }

    @PostMapping("remove")
    public String remove(String id, String oldPassword, RedirectAttributes rttr, HttpServletRequest request)
            throws Exception {
        MemberDto oldmember = service.getById(id);

        boolean passwordMatch = passwordEncoder.matches(oldPassword, oldmember.getPassword());

        if (passwordMatch) {
            service.remove(id);

            rttr.addFlashAttribute("message", "회원 탈퇴하였습니다.");
            request.logout();

            return "redirect:/board/list";

        } else {
            rttr.addAttribute("id", id);
            rttr.addFlashAttribute("message", "암호가 일치하지 않습니다.");
            return "redirect:/member/modify";
        }

    }
}