class RankingController < ApplicationController
  before_action :set_items, only:[:have, :want]

  def have
      # itemをいれるハッシュを生成
      @items_data = Hash.new()
      @items.each do |item|
          # itemごとにidとhave_usersの数をkey,valueで投入
          @items_data.store(item.id,item.have_users.count)
      end
      # have_usersの数でソートして、10を取り出す。配列で返される。
      @have_rank_array = @items_data.sort_by{| key,val | -val }[0..9]
      # 取り出したものを再度hash化して、keyになっているitem.id部分だけを抽出。
      @have_ranking_items_id = @have_rank_array.to_h.keys
  end
    
  def want
      # itemをいれるハッシュを生成
      @items_data = Hash.new()
      @items.each do |item|
          # itemごとにidとhave_usersの数をkey,valueで投入
          @items_data.store(item.id,item.want_users.count)
      end
      # have_usersの数でソートして、10を取り出す。配列で返される。
      @want_rank_array = @items_data.sort_by{| key,val | -val }[0..9]
      # 取り出したものを再度hash化して、keyになっているitem.id部分だけを抽出。
      @want_ranking_items_id = @want_rank_array.to_h.keys
  end
  
  private
  def set_items
      @items = Item.all
  end

end