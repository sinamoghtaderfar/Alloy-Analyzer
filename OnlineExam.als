module OnlineExam

open util/boolean
-- open util/ordering [Time]

sig Time {
  next: lone Time,
  prev: lone Time
}

sig Participant {
  registeredFor: set Exam -> Time
}

sig Exam {
  question: some Question
}

sig ExamSession {
  exam: Exam lone -> Time,
  participant: Participant lone -> Time,
  chosenOptions: Option -> Time,
  status: ExamStatus lone -> Time,
  result: ExamResult lone -> Time
}

sig Question {
  options: some Option
}

sig Option {
  isCorrect: one Bool,
}

abstract sig ExamStatus, ExamResult {}
sig InSession, Concluded, Ready extends ExamStatus {}
sig Failed, Passed, None extends ExamResult {}

fact TimeUniquePrevNext {
  no disj t1, t2: Time | t1.^next = t2.^next or t1.^prev = t2.^prev or (t1.next = t2 and t1.prev = t2)
}

fact TimeNextPrevSymmetry {
  all t1, t2: Time | t1.next = t2 <=> t2.prev = t1
}

fact TimeNoSelfLoop {
  no t: Time | t.next = t or t.prev = t
}

fact ParticipantRegistration {
  all p: Participant, e: Exam, t: Time |
    p.registeredFor.t = e implies one es: ExamSession | es.exam.t = e and es.participant.t = p
}

fact NoSimultaneousExams {
  all p: Participant, t: Time |
    lone es: ExamSession |
      es.participant.t = p and p.registeredFor.t = es.exam.t and es.status.t in InSession
}

fact ExamRegistrationPersistent {
  all p: Participant, t: Time | (some t.next and some p.registeredFor.t) => (p.registeredFor.t in p.registeredFor.(t.next))
}

fact ExamHasQuestions {
  all e: Exam | some e.question
}

fact NoDanglingQuestions {
  all q: Question | one e: Exam | q in e.question
}

fact NoDanglingOptions {
  all o: Option | one q: Question | o in q.options
}

fact ValidOptions {
  all e: Exam |
    all q: e.question |
      #q.options = 4 and one o: Option | o.isCorrect = True and o in q.options
}

fact ChosenOptionsConsistency {
  all es: ExamSession |
    all o: Option, t: Time |
      o in es.chosenOptions.t implies (o in es.exam.t.question.options)
}

fact ChosenOptionsUnchanged{
  all es: ExamSession, t: Time | (some t.prev and some t.next and es.status.t in Concluded)
    implies (es.chosenOptions.t = es.chosenOptions.(t.prev) and es.status.(t.next) in Concluded)
}

fact NoDuplicateQuestionOptions {
  all es: ExamSession | all t: Time | all q: es.exam.t.question |
    no disj o1, o2: q.options |
      o1 in es.chosenOptions.t and o2 in es.chosenOptions.t
}

fact UniqueExamRegistration {
  all es: ExamSession, t: Time |
    (some t.next and es.status.t in Concluded) implies (es.status.(t.next) !in InSession)
}

fact SingleQuestionAnswered {
  all es: ExamSession, t: Time |
    (some t.prev and es.status.t in InSession) implies (#es.chosenOptions.t - #es.chosenOptions.(t.prev) <= 1)
}

fact TimeLimitOfExams {
  all es: ExamSession, t: Time |
    (es.status.t in InSession) implies (#(es.status.Time) <= #(es.exam.t.question))
}

fact SessionRealism {
  all es: ExamSession, t:Time | one es.exam.t <=> one es.participant.t
}

fact NoDuplicateExamSessions {
  all t: Time | no disj es1, es2: ExamSession | es1.participant.t = es2.participant.t or es1.exam.t = es2.exam.t
}

fact ExamSessionPersistent {
  all t: Time, es: ExamSession |
    (some t.next and some es.exam.t and some es.participant.t) => (es.exam.t = es.exam.(t.next) and es.participant.t = es.participant.(t.next))
}

fact ExamStatusRealism {
  all t: Time, es: ExamSession |
    (es.status.t in Concluded) => some es.result.t
}

pred registerForExam[t: Time, e: Exam, es: ExamSession, p: Participant] {
  -- Pre-conditions
  some t.prev
  no es.exam.(t.prev) and no es.participant.(t.prev) and no es.chosenOptions.(t.prev) and no es.status.(t.prev) and no es.result.(t.prev)
  e not in p.registeredFor.(t.prev)
  no es': ExamSession - es | es'.participant.(t.prev) = p and es'.status.t in InSession
  
  -- Frame conditions
  no es': ExamSession - es | es'.participant.(t.prev) = p and es'.status.t != es.status.(t.prev)
  all es': ExamSession - es | es'.participant.(t.prev) = p implies es'.chosenOptions.t = es.chosenOptions.(t.prev)
  all p': Participant - p | p'.registeredFor.t = p'.registeredFor.(t.prev)
  
  -- Post-conditions
  e in p.registeredFor.t
  es.exam.t = e and es.participant.t = p
  es.status.t in Ready
}

pred startExam[e: Exam, es: ExamSession, p: Participant, t: Time] {
  -- Pre-conditions
  some t.prev
  e in p.registeredFor.(t.prev)
  es.exam.(t.prev) = e and es.participant.(t.prev) = p
  es.status.(t.prev) in Ready and es.result.(t.prev) in None and no es.chosenOptions.(t.prev)
  
  -- Frame conditions
  p.registeredFor.(t.prev) = p.registeredFor.t
  es.result.(t.prev) = es.result.t
  es.chosenOptions.(t.prev) = es.chosenOptions.t
  
  -- Post-conditions
  es.status.t in InSession
}

pred answerQuestion[e: Exam, es: ExamSession, p: Participant, t: Time, o: Option] {
  -- Pre-conditions
  some t.prev
  es.status.(t.prev) in InSession and es.result.(t.prev) in None and es.participant.(t.prev) = p and es.exam.(t.prev) = e
  some q: Question | o in q.options and q in e.question
  o not in es.chosenOptions.(t.prev)
  #(es.status.t) < #(e.question)
  
  -- Frame conditions
  es.status.t = es.status.(t.prev)
  es.chosenOptions.(t.prev) = es.chosenOptions.t - o
  
  -- Post-conditions
  es.chosenOptions.t = es.chosenOptions.(t.prev) + o
}

pred System {
  some t: Time | some e: Exam | some p: Participant | some es: ExamSession |
    registerForExam[t, e, es, p]
}

run {} for exactly 8 Time, exactly 2 Participant, exactly 3 Question, exactly 12 Option, exactly 2 Exam, exactly 2 ExamSession, exactly 3 ExamStatus, 1 InSession, 1 Concluded, 1 Ready, exactly 3 ExamResult, 1 Passed, 1 Failed, 1 None
