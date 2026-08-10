page 50210 "UI Sample Dynamic Visible Good"
{
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(ExtraDetails)
            {
                ShowCaption = false;
                Visible = ShowExtraDetails;

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowExtraDetails := Rec."Credit Limit (LCY)" > 0;
    end;

    var
        ShowExtraDetails: Boolean;
}
