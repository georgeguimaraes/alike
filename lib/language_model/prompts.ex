defmodule LanguageModel.Prompts do
  @moduledoc """
  Contains standardized prompts for different language model tasks.
  """

  @doc """
  Returns a prompt for semantic similarity comparison between two sentences.
  """
  def similarity_prompt(sentence1, sentence2) do
    """
    Semantic Similarity Assessment Task:
    
    Evaluate if these two sentences convey the same essential information:
    Sentence 1: "#{sentence1}"
    Sentence 2: "#{sentence2}"
    
    Rules for semantic similarity:
    1. Sentences describing the same action, state, or concept are similar.
    2. Sentences using synonyms or paraphrases are similar.
    3. Sentences about completely different subjects or actions are NOT similar.
    
    Examples:
    - "The cat is sleeping" and "The feline is taking a nap" → true (same action, different words)
    - "It's raining outside" and "Water is falling from the sky" → true (same phenomenon described differently)
    - "The dog is barking" and "The apple is red" → false (completely different subjects and states)
    
    Based on these rules, are the two sentences semantically similar?
    Answer with only one word: true or false.
    """
  end

  @doc """
  General system prompt wrapper for all language model interactions.
  Using the chat format expected by SmolLM2-Instruct models.
  """
  def system_wrapper(content) do
    """
    <|im_start|>system
    You are a semantic analysis assistant specializing in determining if sentences have equivalent meanings.
    
    Your primary function is to identify when two sentences convey the same underlying information,
    even if they use different words, syntax, or phrasing.
    
    For language comparison tasks:
    - Focus exclusively on the core information being communicated
    - Ignore superficial differences in wording or structure
    - Recognize synonyms and paraphrases as semantically equivalent
    - Only respond with "true" or "false" when asked about semantic similarity
    <|im_end|>
    <|im_start|>user
    #{content}
    <|im_end|>
    <|im_start|>assistant
    """
  end
end
