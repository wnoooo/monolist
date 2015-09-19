class RankingController < ApplicationController
  before_action :set_items, only:[:have, :want]

  def have
      # Item.findの引数に条件にあったitemのidを引っ張ってくるActiveRecordのメソッドを連ねる
      # リレーションHaveをitem_idでまとめる。orderでランキング作る。count_item_idはcount(:item_id)で作られたカウント値が入った変数
      # limit(10)で10個だけ取得。count(:item_id)でitem_idを基準にカウントする。keysでitem_idキーだけ取得して配列に入れて返す。
      # 返されたitem_idの配列をたよりに、Itemテーブルから検索してitemが複数入ったオブジェクトを返す。
      # @have_rank_items = Item.find(Have.group(:item_id).order("count_item_id DESC").limit(10).count(:item_id).keys)
      # 上記、ActiveRecordを使って1行で。上のコードを使う場合は、viewでitemをidで探す操作を削除する調整必要
      
      # itemをいれるハッシュを生成
      @items_data = Hash.new()
      @items.each do |item|
          # itemごとにidとhave_usersの数をkey,valueで投入
          @items_data.store(item.id,item.have_users.count)
      end
      # have_usersの数でソートして、10を取り出す。配列で返される。
      @have_rank_array = @items_data.sort_by{| key,val | -val }[0..9]
      # 取り出したものを再度hash化して、keyになっているitem.id部分だけを抽出。
      #@have_ranking_items_id = @have_rank_array.to_h.keys
      # 上記はcloud9にて、ruby2.1以降。下はherokuでarrayクラスのto_hメソッドにエラーが出たため
      @have_ranking_items_id = Hash[*@have_rank_array.flatten].keys

  end
    
  def want
      # @want_rank_items = Item.find(Want.group(:item_id).order("count_item_id DESC").limit(10).count(:item_id).keys)
      # 上記、ActiveRecordを使って1行で。上のコードを使う場合は、viewでitemをidで探す操作を削除する調整必要
      
      # itemをいれるハッシュを生成
      @items_data = Hash.new()
      @items.each do |item|
          # itemごとにidとhave_usersの数をkey,valueで投入
          @items_data.store(item.id,item.want_users.count)
      end
      # have_usersの数でソートして、10を取り出す。配列で返される。
      @want_rank_array = @items_data.sort_by{| key,val | -val }[0..9]
      # 取り出したものを再度hash化して、keyになっているitem.id部分だけを抽出。
      # @want_ranking_items_id = @want_rank_array.to_h.keys
      # 上記はcloud9にて、ruby2.1以降。下はherokuでarrayクラスのto_hメソッドにエラーが出たため
      @want_ranking_items_id = Hash[*@want_rank_array.flatten].keys

  end
  
  private
  def set_items
      @items = Item.all
  end

end