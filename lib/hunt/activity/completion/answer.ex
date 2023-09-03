defmodule Hunt.Activity.Completion.Answer do
  defstruct [:answer]

  def expected(answer) when is_binary(answer) or answer == :any do
    %__MODULE__{answer: answer}
  end

  def verify(%__MODULE__{answer: :any}, params) do
    answer = Map.get(params, "answer", "")
    byte_size(answer) > 10
  end

  def verify(%__MODULE__{answer: expected}, params) do
    answer = Map.get(params, "answer", "") |> String.downcase()
    String.downcase(expected) == answer
  end
end
