<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My First Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<my:navBar active="list" />

<div class="container-md">
    <div class="row">
        <div class="col">


            <c:if test="${not empty message }">
                <div class="alert alert-success">
                        ${message }
                </div>
            </c:if>

            <h1>게시물 목록</h1>
            <table class="table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일시</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${boardList}" var="board">
                    <tr>
                        <td>${board.id }</td>
                        <td>
                            <c:url value="/board/get" var="getLink">
                                <c:param name="id" value="${board.id }"></c:param>
                            </c:url>
                            <a href="${getLink }">
                                    ${board.title }
                            </a>

                            <c:if test="${board.countReply > 0 }">
										<span class="badge rounded-pill text-bg-light">
											<i class="fa-regular fa-comment-dots"></i>
											${board.countReply }
										</span>
                            </c:if>

                            <c:if test="${board.countFile > 0 }">
										<span class="badge rounded-pill text-bg-light">
<%--											<i class="fa-regular fa-floppy-disk"></i>--%>
                                            <i class="fa-solid fa-floppy-disk"></i>
											${board.countFile }
										</span>
                            </c:if>
                        </td>
                        <td>${board.writer }</td>
                        <td>${board.ago }</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- .row>.col -->
    <div class="row">
        <div class="col">
            <nav class="mt-3" aria-label="Page navigation example">
                <ul class="pagination justify-content-center">

                    <%-- 맨앞 버튼은 1페이지가 아니면 존재함 --%>
                    <c:if test="${pageInfo.currentPageNumber ne 1 }">
                        <c:url value="/board/list" var="listLink">
                            <c:param name="page" value="1" />
                            <c:param name="q" value="${param.q }" />
                            <c:param name="t" value="${param.t }" />
                        </c:url>
                        <!-- li.page-item>a.page-link{맨앞버튼} -->
                        <li class="page-item">
                            <a href="${listLink }" class="page-link">
                                <i class="fa-solid fa-angles-left"></i>
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${pageInfo.hasPrevButton }">
                        <c:url value="/board/list" var="listLink">
                            <c:param name="page" value="${pageInfo.jumpPrevPageNumber }"></c:param>
                            <c:param name="q" value="${param.q }" />
                            <c:param name="t" value="${param.t }" />
                        </c:url>
                        <li class="page-item">
                            <a href="${listLink }" class="page-link">
                                <i class="fa-solid fa-angle-left"></i>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="${pageInfo.leftPageNumber }" end="${pageInfo.rightPageNumber }" var="pageNumber">
                        <c:url value="/board/list" var="listLink">
                            <c:param name="page" value="${pageNumber }" />
                            <c:param name="q" value="${param.q }" />
                            <c:param name="t" value="${param.t }" />
                        </c:url>
                        <li class="page-item

					    	<%-- 현재페이지에 active 클래스 추가 --%>
					    	${pageInfo.currentPageNumber eq pageNumber ? 'active' : '' }

					    "><a class="page-link" href="${listLink }">${pageNumber }</a></li>
                    </c:forEach>

                    <c:if test="${pageInfo.hasNextButton }">
                        <c:url value="/board/list" var="listLink">
                            <c:param name="page" value="${pageInfo.jumpNextPageNumber }"></c:param>
                            <c:param name="q" value="${param.q }" />
                            <c:param name="t" value="${param.t }" />
                        </c:url>
                        <li class="page-item">
                            <a href="${listLink }" class="page-link">
                                <i class="fa-solid fa-angle-right"></i>
                            </a>
                        </li>
                    </c:if>


                    <c:if test="${pageInfo.currentPageNumber ne pageInfo.lastPageNumber }">
                        <c:url value="/board/list" var="listLink">
                            <c:param value="${pageInfo.lastPageNumber }" name="page" />
                            <c:param name="q" value="${param.q }" />
                            <c:param name="t" value="${param.t }" />
                        </c:url>
                        <!-- li.page-item>a.page-link{맨뒤버튼} -->
                        <li class="page-item">
                            <a href="${listLink }" class="page-link">
                                <i class="fa-solid fa-angles-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>
</html>









