page 50211 "UI Sample Dynamic Visible Bad"
{
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
                Visible = ShowExtraDetails;
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
