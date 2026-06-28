---
name: commit-worklog
description: git-auto 종료 hook을 사용하는 저장소에서 변경과 검증 결과를 정리하고 자동 commit, GitHub push와 Notion 기록에 적합한 작업 요약을 남긴다. 저장소가 직접 commit·push를 금지하고 hook에 작업 기록을 위임할 때 사용한다.
---

# Commit Worklog

## 목적

Git-auto hook이 안전하고 정확한 작업 기록을 만들 수 있도록 변경 범위와 검증 증거를 정리한다. 이 skill은 직접 commit, push 또는 외부 worklog 업로드를 수행하지 않는다.

## 사용 조건

- 저장소 지침이 git-auto 종료 hook 사용과 직접 commit·push 금지를 선언하는지 확인한다.
- Hook이 없는 저장소에는 해당 저장소의 Git 정책을 적용하고 이 절차를 강제하지 않는다.
- Git 상태를 변경하는 명령은 현재 요청이 명시적으로 허용한 범위를 넘지 않는다.

## 입력 Context

- 사용자 요청, 변경 목표와 제외 범위
- 최종 Git status와 변경 파일 목록
- 실행한 검증 명령, 결과와 미실행 사유
- 남은 위험, 후속 작업과 hook 관련 저장소 지침

## 작업 절차

1. Git status에서 사용자 기존 변경과 이번 작업 변경을 구분한다.
2. 요청 범위 밖 파일, secret, credential와 임시 산출물이 변경에 포함되지 않았는지 확인한다.
3. `.gitauto/`가 ignore 대상이고 staged·tracked 목록에 포함되지 않았는지 확인한다.
4. 변경 목적, 주요 파일과 사용자에게 영향을 주는 결과를 간결하게 정리한다.
5. 검증 명령별 성공·실패·미실행 상태와 실패 후 수정 결과를 사실대로 정리한다.
6. GitHub 기록에는 변경 이유와 review 가능한 범위를, Notion 기록에는 요청·응답 요약과 검증·남은 이슈를 이해할 수 있게 남긴다.
7. 직접 commit, push 또는 publish하지 않고 최종 응답으로 작업을 종료해 Stop hook에 처리를 맡긴다.

## 검증 기준

- 최종 status의 모든 변경이 사용자 요청 또는 기존 변경으로 설명된다.
- Staged 목록과 tracked 파일에 `.gitauto/`, secret과 임시 파일이 없다.
- Worklog 요약이 변경 내용, 검증 결과와 남은 이슈를 서로 구분한다.
- 검증하지 않은 항목과 실패를 성공으로 표현하지 않는다.
- 직접 commit·push·Notion/GitHub publish를 실행하지 않았다.

## 금지 패턴

- Git-auto 저장소에서 직접 commit, push 또는 worklog publish를 수행하지 않는다.
- `.gitauto/` 파일을 수정, staging 또는 commit하지 않는다.
- Secret, token, database ID와 credential 값을 status·log·요약에 출력하지 않는다.
- 변경하지 않은 결과나 실행하지 않은 검증을 worklog에 포함하지 않는다.
- Hook 동작을 확인한다는 이유로 `.codex/hooks`를 요청 없이 수정하지 않는다.

## 완료 기준

- 변경 파일, 검증 결과와 남은 이슈가 정확히 요약된다.
- Git 상태와 ignore/staged 안전 조건이 확인된다.
- 직접 commit·push·publish 없이 hook이 처리할 수 있는 상태로 종료한다.
- Hook 실패가 관찰되면 자동 성공으로 가정하지 않고 pending 및 진단 필요성을 별도 보고한다.

## 참고 문서

- `core/global/agents.fragment.md`
- 저장소 `AGENTS.md`의 git-auto hook 지침
- `.codex/hooks`는 수정 대상이 아니라 저장소 운영 경계로만 참조한다.
