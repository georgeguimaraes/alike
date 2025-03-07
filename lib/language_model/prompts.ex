defmodule LanguageModel.Prompts do
  @moduledoc """
  Contains standardized prompts for different language model tasks.
  """

  @doc """
  Returns a prompt for semantic similarity comparison between two sentences.
  """
  def similarity_prompt(sentence1, sentence2) do
    """
    Do these two sentences have the same core meaning?
    
    Sentence 1: "#{sentence1}"
    Sentence 2: "#{sentence2}"
    
    Answer with true or false only.
    """
  end

  @doc """
  General system prompt wrapper for all language model interactions.
  Using the format shown in SmolLM2 documentation.
  """
  def system_wrapper(content) do
    """
    <|system|>
    You are a helpful AI assistant. Answer questions directly and concisely.
    When evaluating sentence similarity, focus only on the semantic meaning, not the exact wording.
    </|system|>

    <|user|>
    #{content}
    </|user|>

    <|assistant|>
    """
  end
end
