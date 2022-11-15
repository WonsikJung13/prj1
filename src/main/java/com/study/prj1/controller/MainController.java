package com.study.prj1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainController {

    @RequestMapping("/")
    @ResponseBody
    public String home() {
        return "Welcome Home!!";
    }

    @RequestMapping("main")
    public String index() {
        return "index";
    }
}
