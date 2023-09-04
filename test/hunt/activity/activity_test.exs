defmodule Hunt.ActivityTest do
  use Hunt.DataCase, async: true

  describe "submit_answer/2" do
    @written_answer_id "a232e526-ad95-4956-b0dd-b52b3b110fc1"
    @qr_id "4ed0fe52-abc4-4386-8dcc-838a4820bfe4"
    @qr_id2 "bf31f5d1-8247-4414-be8b-9084400e2a08"
    @user %{id: Ecto.UUID.generate()}

    test "written answer valid, not logged in" do
      assert Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: nil) ==
               {:error, "Must log in first"}
    end

    test "written answer valid, logged in" do
      assert {:ok, hunt} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert hunt.user_id == @user.id
      assert hunt.activity_id == @written_answer_id
      assert hunt.approval_state == :approved
      assert hunt.approval_updated_at
      assert hunt.approval_by_id == "00000000-0000-0000-0000-000000000000"
      assert %{"answer" => "Sync Fields"} = hunt.metadata
    end

    test "re-submitted answer (approved) returns an error" do
      assert {:ok, _hunt} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert {:error, cs} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert [activity_id: {"has already been approved", [stale: true]}] = cs.errors
    end

    test "re-submitted answer (rejected) updates the answer" do
      assert {:ok, hunt} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert {:ok, rejected} = Hunt.Activity.reject_answer(hunt, by_user: @user)

      assert {:ok, hunt2} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert hunt2.id == hunt.id
      assert hunt2.id == rejected.id
      assert hunt.user_id == @user.id
      assert hunt.activity_id == @written_answer_id
      assert hunt.approval_state == :approved
      assert hunt.approval_updated_at
      assert hunt.approval_by_id == "00000000-0000-0000-0000-000000000000"
    end

    test "re-submitted answer (pending) updates the answer" do
      assert {:ok, hunt} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      Ecto.Changeset.change(hunt, approval_state: :pending) |> Repo.update!()

      assert {:ok, hunt2} = Hunt.Activity.submit_answer(%{"activity_id" => @written_answer_id, "answer" => "Sync Fields"}, user: @user)
      assert hunt2.id == hunt.id
      assert hunt.user_id == @user.id
      assert hunt.activity_id == @written_answer_id
      assert hunt.approval_state == :approved
      assert hunt.approval_updated_at
      assert hunt.approval_by_id == "00000000-0000-0000-0000-000000000000"
    end

    test "QR code valid" do
      assert {:ok, hunt} = Hunt.Activity.submit_qr_code(@qr_id, :erlang.phash2(@qr_id), user: @user)
      assert hunt.user_id == @user.id
      assert hunt.activity_id == @qr_id
      assert hunt.approval_state == :approved
      assert hunt.approval_updated_at
      assert hunt.approval_by_id == "00000000-0000-0000-0000-000000000000"
    end

    test "QR code valid, not logged in" do
      assert Hunt.Activity.submit_qr_code(@qr_id, :erlang.phash2(@qr_id), user: nil) == {:error, "Must log in first"}
    end

    test "QR code invalid" do
      assert Hunt.Activity.submit_qr_code(@qr_id, "invalid", user: @user) == {:error, "Error completing hunt: invalid code"}
      assert Hunt.Activity.submit_qr_code(@qr_id, :erlang.phash2(@qr_id2), user: @user) == {:error, "Error completing hunt: invalid code"}
      assert Hunt.Activity.submit_qr_code("nope", :erlang.phash2(@qr_id2), user: @user) == {:error, "Error completing hunt: missing nope"}
    end

    test "QR code already completed" do
      assert {:ok, _hunt} = Hunt.Activity.submit_qr_code(@qr_id, :erlang.phash2(@qr_id), user: @user)
      assert {:error, cs} = Hunt.Activity.submit_qr_code(@qr_id, :erlang.phash2(@qr_id), user: @user)
      assert [activity_id: {"has already been approved", [stale: true]}] = cs.errors
    end
  end
end
