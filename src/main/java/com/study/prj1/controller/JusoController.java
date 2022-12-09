package com.study.prj1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("juso")
public class JusoController {

    @RequestMapping("Sample")
    public void jusoPopup() {

    }

    @GetMapping("jusoPopup")
    public void juso22() {
        System.out.println("겟매핑!!!");
    }

    @PostMapping("jusoPopup")
    public void juso(RedirectAttributes rttr) {
        rttr.addFlashAttribute("message", "get juso");
        System.out.println("포스트매핑!!!");
    }
}
