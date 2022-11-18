<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
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
<my:navBar/>
<div class="container-md">
    <div class="row">
        <div class="col">
            <div class="d-flex">
                <h1 class="me-auto">
                    ${board.id }번 게시물

                    <c:url value="/board/modify" var="modifyLink">
                        <c:param name="id" value="${board.id }"></c:param>
                    </c:url>

                    <sec:authentication property="name" var="username"/>

                    <%-- 작성자와 authentication.name 같으면 보여줌 --%>
                    <c:if test="${board.writer == username}">
                        <a class="btn btn-warning" href="${modifyLink }">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </a>
                    </c:if>

                </h1>
                <h1>
                    <button

                            <sec:authorize access="not isAuthenticated()">
                                disabled
                            </sec:authorize>

                            id="likeButton"
                            class="btn btn-light"
                    >

                        <c:if test="${board.liked }">
                            <i class="fa-solid fa-thumbs-up"></i>
                        </c:if>
                        <c:if test="${not board.liked }">
                            <i class="fa-regular fa-thumbs-up"></i>
                        </c:if>

                    </button>
                    <span id="likeCount">
                        ${board.countLike}
                    </span>
                </h1>

            </div>


            <div class="mb-3">
                <label class="form-label">
                    제목
                </label>
                <input class="form-control" type="text" value="${board.title }" readonly>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">
                    본문
                </label>
                <textarea rows="5" class="form-control" readonly>${board.content }</textarea>
            </div>

            <%-- 이미지 출력 --%>
            <div>
                <c:forEach items="${board.fileName }" var="name">
                    <div>
                        <img class="img-fluid img-thumbnail"
                             src="${imgUrl }/${board.id }/${URLEncoder.encode(name, 'utf-8')}" alt="">
                    </div>
                </c:forEach>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">
                    작성자
                </label>
                <input class="form-control" type="text" value="${board.writer }" readonly>
            </div>

            <div class="mb-3">
                <label for="" class="form-label">
                    작성일시
                </label>
                <input class="form-control" type="datetime-local" value="${board.inserted }" readonly>
            </div>


        </div>
    </div>
</div>

<hr>

<%-- 댓글 메시지 토스트 --%>
<div id="replyMessageToast" class="toast align-items-center top-0 start-50 translate-middle-x position-fixed"
     role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
        <div id="replyMessage1" class="toast-body">
            Hello, world! This is a toast message.
        </div>
        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
</div>

<div class="container-md">
    <div class="row">
        <div class="col">
            <h3><i class="fa-solid fa-comments"></i></h3>
        </div>
    </div>
    <div class="row">
        <div class="col">

            <input type="hidden" id="boardId" value="${board.id }">

            <sec:authorize access="isAuthenticated()">
                <%-- 댓글 작성 --%>
                <div class="input-group">
                    <input type="text" class="form-control" id="replyInput1">
                    <button class="btn btn-outline-secondary" id="replySendButton1"><i class="fa-solid fa-reply"></i>
                    </button>
                </div>
            </sec:authorize>
            <sec:authorize access="not isAuthenticated()">
                <div class="alert alert-light">
                    댓글을 작성하시려면 로그인하세요.
                </div>
            </sec:authorize>
        </div>
    </div>

    <div class="row mt-3">
        <div class="col">
            <div class="list-group" id="replyListContainer">
                <%-- 댓글 리스트 출력되는 곳 --%>
            </div>
        </div>
    </div>
</div>


<%-- 댓글 삭제 확인 모달 --%>
<!-- Modal -->
<div class="modal fade" id="removeReplyConfirmModal" tabindex="-1" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">댓글 삭제 확인</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                댓글을 삭제하시겠습니까?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" data-bs-dismiss="modal" id="removeConfirmModalSubmitButton"
                        class="btn btn-danger">삭제
                </button>
            </div>
        </div>
    </div>
</div>

<%-- 댓글 수정 모달 --%>
<!-- Modal -->
<div class="modal fade" id="modifyReplyFormModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5">댓글 수정 양식</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="text" class="form-control" id="modifyReplyInput">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" data-bs-dismiss="modal" id="modifyFormModalSubmitButton" class="btn btn-primary">
                    수정
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
        crossorigin="anonymous"></script>
<script>
    const ctx = "${pageContext.request.contextPath}";

    // 좋아요 버튼 클릭시
    document.querySelector("#likeButton").addEventListener("click", function () {
        const boardId = document.querySelector("#boardId").value;

        fetch(`\${ctx}/board/like`, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({boardId})
        }).then(res => res.json())
            .then(data => {

                if (data.current == 'liked') {
                    document.querySelector("#likeButton").innerHTML = `<i class="fa-solid fa-thumbs-up"></i>`
                } else {
                    document.querySelector("#likeButton").innerHTML = `<i class="fa-regular fa-thumbs-up"></i>`
                }

                document.querySelector("#likeCount").innerText = data.count;
            });
    })


    listReply();

    // 댓글 crud 메시지 토스트
    const toast = new bootstrap.Toast(document.querySelector("#replyMessageToast"));

    document.querySelector("#modifyFormModalSubmitButton").addEventListener("click", function () {
        const content = document.querySelector("#modifyReplyInput").value;
        const id = this.dataset.replyId;
        const data = {id, content};

        fetch(`\${ctx}/reply/modify`, {
            method: "put",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(res => res.json())
            .then(data => {
                document.querySelector("#replyMessage1").innerText = data.message;
                toast.show();
            })
            .then(() => listReply());
    });

    document.querySelector("#removeConfirmModalSubmitButton").addEventListener("click", function () {
        removeReply(this.dataset.replyId);
    });

    function readReplyAndSetModalForm(id) {
        fetch(`\${ctx}/reply/get/\${id}`)
            .then(res => res.json())
            .then(reply => {
                document.querySelector("#modifyReplyInput").value = reply.content;
            });
    }

    function listReply() {
        const boardId = document.querySelector("#boardId").value;
        fetch(`\${ctx}/reply/list/\${boardId}`)
            .then(res => res.json())
            .then(list => {
                const replyListContainer = document.querySelector("#replyListContainer");
                replyListContainer.innerHTML = "";

                for (const item of list) {

                    const modifyReplyButtonId = `modifyReplyButton\${item.id}`;
                    const removeReplyButtonId = `removeReplyButton\${item.id}`;
                    // console.log(item.id);
                    const editButton = `
				<div>
					<button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#modifyReplyFormModal" data-reply-id="\${item.id}" id="\${modifyReplyButtonId}">
						<i class="fa-solid fa-pen"></i>
					</button>
					<button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#removeReplyConfirmModal" data-reply-id="\${item.id}" id="\${removeReplyButtonId}">
						<i class="fa-solid fa-x"></i>
					</button>
				</div>

			`
                    const replyDiv = `
				<div class="list-group-item d-flex">
					<div class="me-auto">
                        <div>
                            <i class="fa-regular fa-user"></i>
                            \${item.writer}
                        </div>
                        <hr>
						<div>
							\${item.content}
						</div>
<hr>
							<small class="text-muted">
								<i class="fa-regular fa-clock"></i>
								\${item.ago}
							</small>
					</div>
					\${item.editable ? editButton : ''}
				</div>`;
                    replyListContainer.insertAdjacentHTML("beforeend", replyDiv);

                    if (item.editable) {
                        // 수정 폼 모달에 댓글 내용 넣기
                        document.querySelector("#" + modifyReplyButtonId)
                            .addEventListener("click", function () {
                                document.querySelector("#modifyFormModalSubmitButton").setAttribute("data-reply-id", this.dataset.replyId);
                                readReplyAndSetModalForm(this.dataset.replyId);
                            });


                        // 삭제확인 버튼에 replyId 옮기기
                        document.querySelector("#" + removeReplyButtonId)
                            .addEventListener("click", function () {
                                // console.log(this.id + "번 삭제버튼 클릭됨");
                                console.log(this.dataset.replyId + "번 댓글 삭제할 예정, 모달 띄움")
                                document.querySelector("#removeConfirmModalSubmitButton").setAttribute("data-reply-id", this.dataset.replyId);
                                // removeReply(this.dataset.replyId);
                            });
                    }
                }
            });
    }

    function removeReply(replyId) {
        // /reply/remove/{id}, method:"delete"
        fetch(ctx + "/reply/remove/" + replyId, {
            method: "delete"
        })
            .then(res => res.json())
            .then(data => {
                document.querySelector("#replyMessage1").innerText = data.message;
                toast.show();
            })
            .then(() => listReply());
    }

    const replySendButton1 = document.querySelector("#replySendButton1");
    if (replySendButton1 != null) {
        document.querySelector("#replySendButton1").addEventListener("click", function () {
            const boardId = document.querySelector("#boardId").value;
            const content = document.querySelector("#replyInput1").value;

            const data = {
                boardId,
                content
            };

            fetch(`\${ctx}/reply/add`, {
                method: "post",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(data)
            })
                .then(res => res.json())
                .then(data => {
                    document.querySelector("#replyInput1").value = "";
                    document.querySelector("#replyMessage1").innerText = data.message;
                    toast.show();
                })
                .then(() => listReply());
        });

    }
</script>
</body>
</html>









