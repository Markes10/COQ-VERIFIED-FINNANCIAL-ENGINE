(**
 * Formally Verified Financial Transaction Ledger
 * System: Coq Proof Assistant (Gallina / Rocq)
 *)

Require Import Arith.
Require Import List.
Import ListNotations.

Definition AccountId := nat.
Definition Amount := nat.

Record Account := {
  acc_id : AccountId;
  acc_balance : Amount
}.

Definition Ledger := list Account.

Record Transaction := {
  tx_from : AccountId;
  tx_to : AccountId;
  tx_amount : Amount
}.

Fixpoint get_balance (l : Ledger) (id : AccountId) : Amount :=
  match l with
  | [] => 0
  | a :: rest => if Nat.eqb (acc_id a) id then acc_balance a else get_balance rest id
  end.

Fixpoint set_balance (l : Ledger) (id : AccountId) (new_bal : Amount) : Ledger :=
  match l with
  | [] => []
  | a :: rest =>
      if Nat.eqb (acc_id a) id
      then {| acc_id := id; acc_balance := new_bal |} :: rest
      else a :: set_balance rest id new_bal
  end.

Fixpoint total_supply (l : Ledger) : Amount :=
  match l with
  | [] => 0
  | a :: rest => acc_balance a + total_supply rest
  end.

Definition process_tx (l : Ledger) (tx : Transaction) : option Ledger :=
  let from_bal := get_balance l (tx_from tx) in
  if (tx_amount tx <=? from_bal) && (negb (Nat.eqb (tx_from tx) (tx_to tx))) then
    let l1 := set_balance l (tx_from tx) (from_bal - tx_amount tx) in
    let to_bal := get_balance l1 (tx_to tx) in
    Some (set_balance l1 (tx_to tx) (to_bal + tx_amount tx))
  else
    None.
