<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My First Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
          integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body>
<my:navBar active="memberInfo"/>


<div class="container-md">
    <div class="row">
        <div class="col">
            <c:if test="${not empty message }">
                <div class="alert alert-success">
                        ${message }
                </div>
            </c:if>

            <h1>${member.id}님의 회원 정보 수정</h1>

            <form id="modifyForm" action="" method="post">
                <div class="mb-3">
                    <label class="form-label">
                        아이디
                    </label>
                    <input class="form-control" type="text" value="${member.id }" readonly>
                </div>

                <div class="mb-3">
                    <label for="" class="form-label">
                        암호
                    </label>
                    <input name="password" class="form-control" type="text" value="${member.password }"
                           id="memberPassword" data-old-value="${member.password }">
                    <div id="passwordText1" class="form-text"></div>
                </div>

                <div hidden id="confirmPassword" class="mb-3">
                    <label for="" class="form-label">
                        암호 확인
                    </label>
                    <input id="passwordInput2" class="form-control" type="text">
                </div>

                <div class="mb-3">
                    <label for="" class="form-label">
                        이메일
                    </label>
                    <div class="input-group">
                        <input id="userEmailInput" class="form-control" type="email" value="${member.email }"
                               name="email" data-old-value="${member.email }">
                        <button disabled id="userEmailExistButton1" class="btn btn-outline-secondary" type="button">
                            중복확인
                        </button>
                    </div>

                    <div id="userEmailText1" class="form-text"></div>

                </div>
                <div class="mb-3">
                    <label for="" class="form-label">
                        가입일자
                    </label>
                    <input class="form-control" type="datetime-local" value="${member.inserted }" readonly>
                </div>
            </form>


            <input class="btn btn-warning" type="submit" value="정보 수정" data-bs-toggle="modal"
                   data-bs-target="#modifyModal">
            <c:url value="/member/remove" var="removeLink"/>
            <input class="btn btn-danger" type="submit" value="회원탈퇴" data-bs-toggle="modal"
                   data-bs-target="#removeModal">

            <form id="removeForm" action="${removeLink }" method="post">
                <input type="hidden" name="id" value="${member.id }">
            </form>

        </div>
    </div>
</div>

<%-- 수정시 암호 인증 --%>
<div class="modal fade" id="modifyModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">기존 암호를 입력해주세요</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <input type="text" class="form-control" id="inputPassword">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="modifyConfirmButton">제출</button>
            </div>
        </div>
    </div>
</div>


<%-- 삭제 확인 모달(암호 인증) --%>
<div class="modal fade" id="removeModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">암호를 입력해주세요</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <input type="text" class="form-control" id="inputPasswordForRemove">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="removeConfirmButton">제출</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous">
</script>

<script>

    // 암호 변경하지 않을 시 암호확인 창 삭제
    document.querySelector("#memberPassword").addEventListener("keyup", function () {
        const oldPassword = document.querySelector("#memberPassword").dataset.oldValue;
        const newPassword = document.querySelector("#memberPassword").value;

        if (oldPassword == newPassword) {
            document.querySelector("#confirmPassword").setAttribute("hidden","hidden");
            document.querySelector("#passwordText1").innerText = "";

        } else {
            document.querySelector("#confirmPassword").removeAttribute("hidden");
        }
    })

    const ctx = "${pageContext.request.contextPath}";

    const emailInput1 = document.querySelector("#userEmailInput");
    const emailButton1 = document.querySelector("#userEmailExistButton1");
    const emailText1 = document.querySelector("#userEmailText1");

    // 값 변경 시 중복확인 요청
    emailInput1.addEventListener("keyup", function () {
        const oldValue = emailInput1.dataset.oldValue;
        const newValue = emailInput1.value;
        if (oldValue == newValue) {
            // 기존 이메일과 같으면 아무일도 일어나지 않음
            emailText1.innerText = "";
            emailButton1.setAttribute("disabled", "disabled");
        } else {
            // 기존 이메일과 다르면 중복체크 요청
            emailText1.innerText = "이메일 중복확인을 해주세요.";
            emailButton1.removeAttribute("disabled");
            emailText1.setAttribute("style", "color:red");
        }
    });

    // 이메일 중복 확인

    document.querySelector("#userEmailExistButton1").addEventListener("click", function () {
        const userEmail = document.querySelector("#userEmailInput").value;

        fetch(`\${ctx}/member/existEmail`, {
            method: "post",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({userEmail})
        })
            .then(res => res.json())
            .then(data => {
                document.querySelector("#userEmailText1").innerText = data.message;
            });
    });

    // 암호 입력 일치하는지 확인
    const passwordInput1 = document.querySelector("#memberPassword");
    const passwordInput2 = document.querySelector("#passwordInput2");
    const passwordText1 = document.querySelector("#passwordText1");

    passwordInput1.addEventListener("keyup", matchPassword);
    passwordInput2.addEventListener("keyup", matchPassword);

    function matchPassword() {
        const pwConfirm = document.querySelector("#confirmPassword").getAttribute("hidden");
        if (pwConfirm != null) {
            passwordInput1.innerText = "";
        } else {
            if (passwordInput1.value == passwordInput2.value) {
                passwordText1.innerText = "패스워드가 일치 합니다.";
                passwordText1.removeAttribute("style");
            } else {
                passwordText1.innerText = "패스워드가 일치하지 않습니다.";
                passwordText1.setAttribute("style" ,"color: #dc3545");
            }
        }
    }

    document.querySelector("#modifyConfirmButton").addEventListener("click", function () {
        const modalInput = document.querySelector("#inputPassword").value;
        const memberPassword = document.querySelector("#memberPassword").dataset.oldValue;
        const modifyForm = document.querySelector("#modifyForm")

        if (memberPassword == modalInput) {
            modifyForm.submit();
        } else {
            alert("암호가 틀렸습니다. 다시 입력해주세요.")
        }

    })

    // 삭제확인 버튼 클릭하면 삭제 form 전송
    document.querySelector("#removeConfirmButton").addEventListener("click", function () {

        const modalInput = document.querySelector("#inputPasswordForRemove").value;
        const memberPassword = document.querySelector("#memberPassword").value;
        const removeForm = document.querySelector("#removeForm")

        if (memberPassword == modalInput) {
            removeForm.submit();
        } else {
            alert("암호가 틀렸습니다. 다시 입력해주세요.")
        }
    });
</script>

</body>
</html>
