---
name: query-performance-review
description: Database query의 access pattern, 데이터 규모, index 후보, N+1·full scan·over-fetching 위험을 검토하고 측정 계획을 수립한다. 조회 latency나 database 부하에 영향을 주는 query 설계·변경을 review할 때 사용한다.
---

# Query Performance Review

## 목적

Query 비용을 실제 access pattern과 데이터 분포에 연결해 위험을 식별하고 검증 가능한 최적화 후보를 제시한다. 특정 query 언어, ORM과 database optimizer 세부사항은 다루지 않는다.

## 사용 조건

- 신규·변경 query, 조회 흐름 또는 성능 문제를 검토할 때 적용한다.
- 정확성과 data integrity를 성능보다 먼저 보존한다.
- 설계 초안에서는 측정 계획을 세우고 실제 explain plan은 구현 및 실행 환경이 준비된 단계에서만 확인한다.

## 입력 Context

- Use case별 access pattern, 빈도와 latency 목표
- Query 조건, 정렬, pagination, join/fetch와 반환 shape
- 데이터 규모, cardinality, 분포와 증가율
- 현재 index, 호출 횟수, metric과 성능 test 결과

## 작업 절차

1. Query의 읽기 경로, 호출 빈도와 허용 latency를 정의한다.
2. Filter·join·sort·pagination field와 예상 cardinality를 확인한다.
3. 반복 접근에서 N+1, full scan, 불필요한 count와 over-fetching 가능성을 식별한다.
4. 조건·정렬을 지원할 index 후보와 column 순서를 access pattern 기준으로 검토한다.
5. Index의 write·storage 비용과 기존 index 중복을 함께 평가한다.
6. Projection, batch, query 수 축소와 pagination 변경 후보를 정확성 영향과 비교한다.
7. 구현 단계에서 대표 데이터와 실제 실행 환경으로 explain plan, latency와 resource 사용을 측정한다.
8. Finding과 측정 전 가정을 구분해 우선순위를 정리한다.

## 검증 기준

- 성능 판단이 access pattern, 데이터 분포와 목표 수치에 연결된다.
- N+1, full scan과 over-fetching의 발생 조건 및 호출 영향이 설명된다.
- Index 후보마다 대상 query와 write/storage tradeoff가 있다.
- Explain plan은 실제 구현·환경에서 확인되며 설계 추정으로 대체되지 않는다.
- 최적화 후 결과 정확성과 대표 부하의 회귀를 검증한다.

## 금지 패턴

- 데이터 규모와 실행 증거 없이 index나 cache를 만능 해결로 제안하지 않는다.
- 설계 문서만 보고 실제 explain plan 결과를 추정해 작성하지 않는다.
- N+1을 숨기기 위해 무제한 join/fetch와 대형 projection을 사용하지 않는다.
- 성능을 위해 정렬 안정성, 권한 filter와 data integrity를 약화하지 않는다.

## 완료 기준

- 성능 위험, 발생 조건과 영향도가 정리된다.
- Index/query 후보와 측정 계획이 tradeoff를 포함한다.
- 구현 단계라면 explain plan 및 대표 성능 결과가 기록된다.
- 미측정 가정과 product-specific 확인 필요성이 보고된다.

## 참고 문서

- `stacks/database/rdb/agents.fragment.md`
- `stacks/database/nosql/agents.fragment.md`
- 프로젝트의 query metric과 성능 기준
