<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My First Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
          integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body>
<my:navBar active="register"/>
<div class="container-md">
    <div class="row">
        <div class="col">
            <h1>게시물 작성</h1>
            <form id="registerForm1" action="" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="" class="form-label">제목</label>
                    <input required="required" type="text" class="form-control" name="title">
                </div>
                <div class="mb-3">
                    <label for="" class="form-label">본문</label>
                    <textarea required="required" rows="5" class="form-control" name="content"></textarea>
                </div>

                <div class="mb-3">
                    <label for="" class="form-label">파일</label>
                    <input multiple type="file" accept="image/*" class="form-control" name="files">
                </div>

                <div class="mb-3">
                    <label for="" class="form-label">작성자</label>
                    <input
                            value="<sec:authentication property="name"/>"
                            readonly type="text" class="form-control" name="writer">
                </div>

                <input id="submitButton1" class="btn btn-primary" type="submit" value="등록">


            </form>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
<script>
    document.querySelector("#submitButton1").addEventListener("click", function (e) {
        // submit 진행 중지
        e.preventDefault();

        // 제목input 입력한 값 가져와서
        // 빈칸만 있는지 확인?
        let titleValue = document.querySelector(`#registerForm1 input[name="title"]`).value
        // 본문 textarea 입력한 값 가져와서
        // 빈칸만 있는지 확인?
        let contentValue = document.querySelector(`#registerForm1 textarea[name="content"]`).value
        // 작성자 input 값 가져와서
        // 빈칸만 있는지 확인?
        let writerValue = document.querySelector(`#registerForm1 input[name="writer"]`).value

        // 위 테스트 다 통과하면 submit
        if (titleValue.trim() != ""
            && contentValue.trim() != ""
            && writerValue.trim() != "") {

            document.querySelector("#registerForm1").submit();
        } else {
            // 적절한 메세지 표시....
            if (titleValue.trim() == "") {
                alert("제목을 입력해주세요")
            } else if (contentValue.trim() == "") {
                alert("본문을 입력해주세요")
            } else if (writerValue.trim() == "") {
                alert("작성자를 입력해주세요")
            }
        }


    });

</script>
</body>
</html>













