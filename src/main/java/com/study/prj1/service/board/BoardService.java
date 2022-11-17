package com.study.prj1.service.board;

import com.study.prj1.domain.board.BoardDto;
import com.study.prj1.domain.board.PageInfo;
import com.study.prj1.mapper.board.BoardMapper;
import com.study.prj1.mapper.board.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class BoardService {
    @Autowired
    private BoardMapper boardMapper;

    @Autowired
    private ReplyMapper replyMapper;

    @Autowired
    private S3Client s3Client;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    public int register(BoardDto board, MultipartFile[] files) {
        // db에 게시물 정보 저장
        int cnt = boardMapper.insert(board);

        for (MultipartFile file : files) {
            if (file != null && file.getSize() > 0) {
                // db에 파일 정보 저장
                boardMapper.insertFile(board.getId(), file.getOriginalFilename());

                uploadFile(board.getId(), file);
            }
        }

        return cnt;
    }

    private void uploadFile(int id, MultipartFile file) {
        try {
            // S3에 파일 저장
            // 키 생성
            String key = "prj1/board/" + id + "/" + file.getOriginalFilename();

            // putObjectRequest
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .acl(ObjectCannedACL.PUBLIC_READ)
                    .build();

            // requestBody
            RequestBody requestBody = RequestBody.fromInputStream(file.getInputStream(), file.getSize());

            // object(파일) 올리기
            s3Client.putObject(putObjectRequest, requestBody);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<BoardDto> listBoard(int page, String type, String keyword, PageInfo pageInfo) {
        int records = 10;
        int offset = (page - 1) * records;

        int countAll = boardMapper.countAll(type, "%" + keyword + "%"); // SELECT Count(*) FROM Board
        int lastPage = (countAll - 1) / records + 1;

        int leftPageNumber = (page - 1) / 10 * 10 + 1;
        int rightPageNumber = leftPageNumber + 9;
        rightPageNumber = Math.min(rightPageNumber, lastPage);

        // 이전버튼 유무
        boolean hasPrevButton = page > 10;
        // 다음버튼 유무
        boolean hasNextButton = page <= ((lastPage - 1) / 10 * 10);

        // 이전버튼 눌렀을 때 가는 페이지 번호
        int jumpPrevPageNumber = (page - 1) / 10 * 10 - 9;
        int jumpNextPageNumber = (page - 1) / 10 * 10 + 11;

        pageInfo.setHasPrevButton(hasPrevButton);
        pageInfo.setHasNextButton(hasNextButton);
        pageInfo.setJumpPrevPageNumber(jumpPrevPageNumber);
        pageInfo.setJumpNextPageNumber(jumpNextPageNumber);
        pageInfo.setCurrentPageNumber(page);
        pageInfo.setLeftPageNumber(leftPageNumber);
        pageInfo.setRightPageNumber(rightPageNumber);
        pageInfo.setLastPageNumber(lastPage);

        return boardMapper.list(offset, records, type, "%" + keyword + "%");
    }

    public BoardDto get(int id, String username) {
        // TODO Auto-generated method stub
        return boardMapper.select(id, username);
    }

    public int update(BoardDto board, MultipartFile[] addFiles, List<String> removeFiles) {
        int boardId = board.getId();

        // removeFiles 에 있는 파일명으로

        if (removeFiles != null) {
            for (String fileName : removeFiles) {
                // 1. File 테이블에서 record 지우기
                boardMapper.deleteFileByBoardIdAndFileName(boardId, fileName);
                // 2. S3 저장소에 실제 파일(object) 지우기
                deleteFile(boardId, fileName);
            }
        }


        for (MultipartFile file : addFiles) {
            if (file != null && file.getSize() > 0) {
                String name = file.getOriginalFilename();
                // File table에 해당파일명 지우기
                boardMapper.deleteFileByBoardIdAndFileName(boardId, name);

                // File table에 파일명 추가
                boardMapper.insertFile(boardId, name);

                // S3 저장소에 실제 파일(object) 추가
                uploadFile(boardId, file);
            }

        }


        return boardMapper.update(board);
    }

    public int remove(int id) {
        BoardDto board = boardMapper.select(id);

        List<String> fileNames = board.getFileName();

        if (fileNames != null) {
            for (String fileName : fileNames) {
                // s3 저장소의 파일 지우기
                deleteFile(id, fileName);
            }
        }

        // db 파일 records 지우기
        boardMapper.deleteFileByBoardId(id);


        // 게시물의 댓글들 지우기
        replyMapper.deleteByBoardId(id);

        boardMapper.deleteLikeByBoardId(id);

        // 게시물 지우기
        return boardMapper.delete(id);
    }

    private void deleteFile(int id, String fileName) {
        String key = "prj1/board/" + id + "/" + fileName;
        DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();
        s3Client.deleteObject(deleteObjectRequest);
    }

    public Map<String, Object> updateLike(String boardId, String memberId) {
        Map<String, Object> map = new HashMap<>();

        int cnt = boardMapper.getLikeByBoardIdAndMemberId(boardId, memberId);
        if (cnt == 1) {
            // boardId와 username으로 좋아요 테이블 검색해서 있으면?
            // 삭제
            boardMapper.deleteLike(boardId, memberId);
            map.put("current", "not liked");

        } else {
            // 없으면?
            // insert
            boardMapper.insertLike(boardId, memberId);
            map.put("current", "liked");
        }

        int countAll = boardMapper.countLikeByBoardId(boardId);
        // 현재 몇개인지
        map.put("count", countAll);

        return map;
    }

    public BoardDto get(int id) {
        return get(id, null);
    }
}
