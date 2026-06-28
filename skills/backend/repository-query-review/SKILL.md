---
name: repository-query-review
description: Backend repository와 query 변경의 목적, 조회 조건, 정렬·pagination, join·fetch 범위, 성능과 data integrity 영향을 검토한다. Persistence 접근 계약이나 조회 구현이 변경되는 review에서 사용한다.
---

# Repository Query Review

## 목적

Repository contract와 query가 use case에 필요한 데이터만 정확하고 예측 가능한 비용으로 제공하는지 검토한다. 특정 ORM, query DSL, driver와 framework API 세부사항은 다루지 않는다.

## 사용 조건

- Repository method, query, projection 또는 조회 조건이 추가·변경될 때 적용한다.
- 단순 코드 스타일보다 결과 정확성, cardinality와 비용을 우선한다.
- 수정 요청이 없으면 finding만 보고하고 구현을 변경하지 않는다.

## 입력 Context

- Query를 사용하는 use case와 기대 결과
- Repository contract, 데이터 관계와 무결성 제약
- Filter, sort, pagination, join/fetch 및 projection
- 대표 데이터 규모, 호출 빈도와 기존 test·성능 증거

## 작업 절차

1. Query의 소비자, 반환 shape, cardinality와 최신성 요구를 확인한다.
2. 조회 조건이 필수·선택 값, null/부재와 권한 범위를 정확히 표현하는지 검토한다.
3. Sort가 결정적이며 pagination 방식, 기본값과 최대 범위에 맞는지 확인한다.
4. Join/fetch가 필요한 관계만 포함하고 중복 행, 누락, Cartesian 증가와 over-fetching 위험을 확인한다.
5. 반복 호출에 따른 N+1, full scan과 불필요한 count 가능성을 식별한다.
6. Index·constraint와 query 변경이 data integrity 및 쓰기 경로에 미치는 영향을 검토한다.
7. Finding을 정확성, 성능, 계약과 test 누락으로 분류해 근거와 함께 정리한다.

## 검증 기준

- Query 결과가 use case의 필터, 정렬, cardinality와 권한 요구에 맞는다.
- Pagination이 안정된 순서와 제한을 가지며 중복·누락 조건을 설명한다.
- Join/fetch 범위와 projection이 필요한 데이터에 한정된다.
- N+1, full scan, over-fetching과 index 영향이 대표 규모에서 검토된다.
- Repository contract 및 통합 test가 정상·경계·빈 결과를 포함한다.

## 금지 패턴

- 특정 ORM 동작을 확인 없이 일반 규칙으로 가정하지 않는다.
- Repository가 화면별 임시 shape와 business workflow를 무제한 소유하게 하지 않는다.
- 정렬 없는 pagination이나 제한 없는 목록 query를 승인하지 않는다.
- 성능 근거 없이 eager fetch, join 또는 index를 추가하도록 제안하지 않는다.

## 완료 기준

- 정확성, 성능과 data integrity finding이 위치·영향과 함께 정리된다.
- Repository 책임과 use case 요구가 일치한다.
- 필요한 query·integration test와 미검증 성능 조건이 명시된다.
- Product/ORM-specific 확인 항목이 일반 결론과 구분된다.

## 참고 문서

- `stacks/database/rdb/agents.fragment.md`
- `skills/database/query-performance-review/SKILL.md`
- 프로젝트의 repository 및 데이터 소유권 지침
