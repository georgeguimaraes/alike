defmodule LanguageModel.Prompts do
  @moduledoc """
  Contains standardized prompts for different language model tasks.
  """

  @doc """
  Returns a prompt for semantic similarity comparison between two sentences.
  """
  def similarity_prompt(sentence1, sentence2) do
    """
    Q: Are "#{sentence1}" and "#{sentence2}" semantically similar?
    """
  end

  @doc """
  General system prompt wrapper for all language model interactions.
  Using Llama 2-Chat format with few-shot prompting for better instruction following.
  """
  def system_wrapper(content) do
    """
    <s>[INST] <<SYS>>
    You are a semantic similarity classifier. Answer with only "true" or "false".
    
    Examples:
    Q: Are "The dog is running fast" and "The canine is jogging quickly" semantically similar?
    A: true
    
    Q: Are "The car is red" and "The sky is blue" semantically similar?
    A: false
    
    Q: Are "It's raining outside" and "Water is falling from the clouds" semantically similar?
    A: true
    
    Q: Are "I love pizza" and "Mathematics is difficult" semantically similar?
    A: false
    
    Q: Are "The book is interesting" and "The novel is fascinating" semantically similar?
    A: true
    
    Q: Are "The weather is nice today" and "I enjoy reading books" semantically similar?
    A: false
    <</SYS>>

    #{content} [/INST]
    """
  end
end
