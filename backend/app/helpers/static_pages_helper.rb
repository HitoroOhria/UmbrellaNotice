module StaticPagesHelper
  def display_article
    @article_counter ||= 0
    @article_counter += 1

    "第#{@article_counter}条"
  end
end
