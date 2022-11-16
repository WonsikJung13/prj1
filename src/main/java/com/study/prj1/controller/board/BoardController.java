package com.study.prj1.controller.board;

import com.study.prj1.domain.board.BoardDto;
import com.study.prj1.domain.board.PageInfo;
import com.study.prj1.service.board.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("board")
@RequiredArgsConstructor
public class BoardController {

    @Autowired
    private BoardService service;

    @GetMapping("register")
    public void register() {
        // 게시물 작성 view로 포워드
        // /WEB-INF/views/board/register.jsp
    }

    @PostMapping("register")
    public String register(
            BoardDto board,
            MultipartFile[] files,
            RedirectAttributes rttr) {
        // * 파일업로드
        // 1. web.xml
        //    dispatcherServlet 설정에 multipart-config 추가
        // 2. form 에 enctype="multipart/form-data" 속성 추가
        // 3. Controller의 메소드 argument type : MultipartFile

        // request param 수집/가공
//		System.out.println(files.length);
//		for (MultipartFile file : files) {
//			System.out.println(file.getOriginalFilename());
//		}

        // business logic
        int cnt = service.register(board, files);

        if (cnt == 1) {
            rttr.addFlashAttribute("message", "새 게시물이 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("message", "새 게시물이 등록되지 않았습니다.");
        }

        // /board/list로 redirect
        return "redirect:/board/list";
    }

    @GetMapping("list")
    public void list(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "t", defaultValue = "all") String type,
            @RequestParam(name = "q", defaultValue = "") String keyword,
            PageInfo pageInfo,
            Model model) {
        // request param
        // business logic
        List<BoardDto> list = service.listBoard(page, type, keyword, pageInfo);

        // add attribute
        model.addAttribute("boardList", list);
        // forward
    }

    // 위 list 메소드 파라미터 PageInfo에 일어나는 일을 풀어서 작성
	/*
	private void list2(
			@RequestParam(name = "page", defaultValue = "1") int page,
			HttpServletRequest request,
			Model model) {
		// request param
		PageInfo pageInfo = new PageInfo();
		pageInfo.setLastPageNumber(Integer.parseInt(request.getParameter("lastPageNumber")));
		model.addAttribute("pageInfo", pageInfo);

		// business logic
		List<BoardDto> list = service.listBoard(page, pageInfo);

		// add attribute
		model.addAttribute("boardList", list);
		// forward
	}
	*/


    @GetMapping("get")
    public void get(
            // @RequestParam 생략 가능
            @RequestParam(name = "id") int id,
            Model model) {
        // req param
        // business logic (게시물 db에서 가져오기)
        BoardDto board = service.get(id);
        // add attribute
        model.addAttribute("board", board);
        // forward

    }

    @GetMapping("modify")
    @PreAuthorize("@boardSecurity.checkWriter(authentication.name, #id)")
    public void modify(int id, Model model) {
        BoardDto board = service.get(id);
        model.addAttribute("board", board);

    }

    @PostMapping("modify")
    @PreAuthorize("@boardSecurity.checkWriter(authentication.name, #board.id)")

    public String modify(
            BoardDto board,
            @RequestParam("files") MultipartFile[] addFiles,
            @RequestParam(name = "removeFiles", required = false) List<String> removeFiles,
            RedirectAttributes rttr) {

        int cnt = service.update(board, addFiles, removeFiles);

        if (cnt == 1) {
            rttr.addFlashAttribute("message", board.getId() + "번 게시물이 수정되었습니다.");
        } else {
            rttr.addFlashAttribute("message", board.getId() + "번 게시물이 수정되지 않았습니다.");
        }

        return "redirect:/board/list";
    }

    @PostMapping("remove")
    @PreAuthorize("@boardSecurity.checkWriter(authentication.name, #id)")

    public String remove(int id, RedirectAttributes rttr) {
        int cnt = service.remove(id);

        if (cnt == 1) {
            // id번 게시물이 삭제되었습니다.
            rttr.addFlashAttribute("message", id + "번 게시물이 삭제되었습니다.");
        } else {
            // id번 게시물이 삭제되지 않았습니다.
            rttr.addFlashAttribute("message", id + "번 게시물이 삭제되지 않았습니다.");
        }

        return "redirect:/board/list";
    }
}
