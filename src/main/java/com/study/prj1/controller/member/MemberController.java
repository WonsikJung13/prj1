package com.study.prj1.controller.member;


import com.study.prj1.domain.member.MemberDto;
import com.study.prj1.service.member.MemberService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("member")
public class MemberController {

    @Setter(onMethod_ = @Autowired)
    private MemberService service;

    @PostMapping("existEmail")
    @ResponseBody
    public Map<String, Object> existEmail(@RequestBody Map<String, String> req) {

        Map<String, Object> map = new HashMap<>();

        MemberDto member = service.getEmail(req.get("userEmail"));


        if (member == null) {
            map.put("status", "not exist");
            map.put("message", "사용 가능한 이메일입니다");
        } else {
            map.put("status", "exist");
            map.put("message", "이미 존재하는 이메일입니다");
        }

        return map;
    }


    @GetMapping("existId/{id}")
    @ResponseBody
    public Map<String, Object> existId(@PathVariable String id) {

        Map<String, Object> map = new HashMap<>();

        MemberDto member = service.select(id);


        if (member == null) {
            map.put("status", "not exist");
            map.put("message", "사용 가능한 아이디입니다");
        } else {
            map.put("status", "exist");
            map.put("message", "이미 존재하는 아이디입니다");
        }

        return map;
    }

    @GetMapping("signup")
    public void signup() {

    }

    @PostMapping("signup")
    public String signup(MemberDto member, RedirectAttributes rttr) {

        int cnt = service.insert(member);

        // 가입 잘되면...
        rttr.addFlashAttribute("message", "회원가입 완료되었습니다");
        return "redirect:/member/list";
    }

    @GetMapping("list")
    public void list(Model model) {
        model.addAttribute("memberList", service.list());
    }

    @GetMapping({"info", "modify"})
    public void info(String id, Model model) {

        model.addAttribute("member", service.select(id));
    }

    @PostMapping("modify")
    public String modify(
            MemberDto member, RedirectAttributes rttr) {

        int cnt = service.modify(member);


        rttr.addAttribute("id", member.getId());
        if (cnt == 1) {
            rttr.addFlashAttribute("message", "회원 정보가 수정되었습니다");
            return "redirect:/member/info";
        } else {
            rttr.addFlashAttribute("message", "회원 정보가 수정되지 않았습니다");
            return "redirect:/member/modify";
        }
    }

    @PostMapping("remove")
    public String remove(String id, RedirectAttributes rttr) {
        int cnt = service.remove(id);

        rttr.addFlashAttribute("message", "회원 탈퇴가 완료되었습니다");

        return "redirect:/member/list";
    }
}