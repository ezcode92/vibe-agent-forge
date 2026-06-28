---
name: schema-change-review
description: Database schema 변경의 하위 호환성, migration 순서, index·constraint 영향과 rollback 또는 roll-forward 가능성을 검토한다. 운영 데이터와 application 배포에 영향을 주는 schema 변경을 review할 때 사용한다.
---

# Schema Change Review

## 목적

Schema 변경이 기존 application과 데이터에 미치는 영향을 배포 전후 단계별로 검토하고 안전한 migration 및 복구 조건을 제시한다. 특정 database 제품의 DDL 문법과 migration 도구 사용법은 다루지 않는다.

## 사용 조건

- Table/collection 구조, field, type, index 또는 constraint 변경이 있을 때 적용한다.
- 현재·이전 application version의 공존 여부와 데이터 규모를 확인한다.
- 실행 요청이 없으면 migration을 적용하지 않고 review 결과만 제공한다.

## 입력 Context

- 현재 schema, 제안 변경과 business invariant
- Application read/write 경로와 배포 순서
- 데이터 규모, null·중복·잘못된 기존 값의 분포
- Index, constraint, lock과 운영 복구 요구

## 작업 절차

1. 변경 목적과 읽기·쓰기 계약의 차이를 확인한다.
2. 이전 application과 새 schema, 새 application과 이전 schema의 호환성을 각각 검토한다.
3. 추가, backfill, dual-read/write, 전환과 제거가 필요한지 단계별 순서를 설계한다.
4. Type·nullability·constraint 변경이 기존 데이터와 동시 write에 미치는 영향을 확인한다.
5. Index 추가·삭제가 read 성능, write 비용, lock과 배포 시간에 미치는 영향을 검토한다.
6. 실패 시 rollback 가능성을 확인하고 데이터 변경이 비가역적이면 roll-forward 및 복구 전략을 정한다.
7. 각 단계의 검증 query, metric, 중단 조건과 완료 증거를 정리한다.

## 검증 기준

- Application/schema version 조합별 호환 여부가 명시된다.
- Migration 순서가 무중단 또는 합의된 중단 요구와 일치한다.
- 기존 데이터가 새 constraint와 type을 만족하는지 확인할 방법이 있다.
- Index/constraint 변경의 성능·lock·쓰기 영향이 검토된다.
- Rollback 또는 roll-forward 조건과 데이터 복구 책임이 명확하다.

## 금지 패턴

- 파괴적 변경과 application 전환을 검증 없이 한 단계로 수행하지 않는다.
- 기존 데이터 분포를 확인하지 않고 non-null·unique constraint를 추가하지 않는다.
- 모든 migration이 rollback 가능하다고 가정하지 않는다.
- Product별 lock·DDL 특성을 확인하지 않고 운영 영향을 단정하지 않는다.

## 완료 기준

- 호환성 matrix, 단계별 migration과 배포 순서가 정리된다.
- Index·constraint 및 데이터 integrity 영향이 근거를 가진다.
- 실패 복구, 검증과 중단 조건이 명시된다.
- Product-specific 확인 항목과 미검증 운영 위험이 보고된다.

## 참고 문서

- `stacks/database/rdb/agents.fragment.md`
- `skills/common/code-review/SKILL.md`
- 프로젝트의 schema 및 배포 정책
