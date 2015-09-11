class OwnershipsController < ApplicationController
  before_action :logged_in_user

  # 商品に対してHave,Wantを制御するコントローラ
  def create
    # 商品のasinパラメータを取得
    if params[:asin]
      # itemsテーブルからasinパラメータで検索。なかった場合は受けたasinパラメータでitem.newして新しいitemレコードを生成
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      # asinパラメータがない場合は、item_idでitemsテーブルを検索して取得
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合（以前にhave,wantされてない場合）はAmazonのデータを登録する。
    if @item.new_record?
      begin
        # TODO 商品情報の取得 Amazon::Ecs.item_lookupを用いてください
        response = {}
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!
    end

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値ににHaveボタンが押された時には「Have」,
    # Wantボタンがされた時には「Want」が設定されています。
    

  end

  def destroy
    @item = Item.find(params[:item_id])

    # TODO 紐付けの解除。 
    # params[:type]の値ににHavedボタンが押された時には「Have」,
    # Wantedボタンがされた時には「Want」が設定されています。

  end
end
