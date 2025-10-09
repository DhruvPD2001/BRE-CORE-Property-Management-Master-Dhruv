pageextension 50104 "MyRoleCenterExtension" extends "Business Manager Role Center"
{
    actions
    {
        // addfirst(embedding)
        // {
        //     action("Project Management")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Project Management';
        //         RunObject = Page "Property Registration List";
        //     }
        // }
        addfirst(sections)
        {
            group(Action42)
            {
                Caption = 'Property Management';

                action(CountryList)
                {
                    Caption = 'Countries';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Country List";
                }
                action(EmirateList)
                {
                    Caption = 'Emirates';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Emirate List";
                }
                action(CommunityList)
                {
                    Caption = 'Communities';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Community List";
                }


                action(PropertyClassification)
                {
                    Caption = 'Property Classifications';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Classification List";
                }
                action(PropertyType)
                {
                    Caption = 'Property Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Type List";
                }
                action(UnitType)
                {
                    Caption = 'Unit Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Secondary Classification List";
                }


                action(OwnerProfile)
                {
                    Caption = 'Owner Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Owner Profile List";
                }
                action(TenantProfile)
                {
                    Caption = 'Tenant Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Customer List";
                }
                action(UOM)
                {
                    Caption = 'Unit of Measure';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Units of Measure";
                }
                action(PrimaryItemList)
                {
                    Caption = 'Primary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Item List";
                }
                action(SecondaryItemList)
                {
                    Caption = 'Secondary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Item List";
                    RunPageView = where("Item type template" = const("Secondary Item"));
                }
                action(CategoryList)
                {
                    Caption = 'Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Category List";
                }
                action(BankAccountList)
                {
                    Caption = 'Bank Accounts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Bank Account List";
                }
                action(PaymentTypeList)
                {
                    Caption = 'Payment Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Type List";
                }
                action(VendorCategoryList)
                {
                    Caption = 'Vendor Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Vendor Category List";
                }
                action(CalculationTypeList)
                {
                    Caption = 'Calculation Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Calculation Type List";
                }

                action(PeopertyRegistration)
                {
                    Caption = ' Property Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Registration List";
                }



                action(UnitList)
                {
                    Caption = 'Unit Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Item List";
                    RunPageView = where("Item type template" = const("Unit Service"));
                }
                action(LeaseProposal)
                {
                    Caption = 'Lease Proposals';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lease Proposal List";
                }

                action(TenancyContract)
                {
                    Caption = 'Tenancy Contracts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Tenancy Contract List";
                }



                action(MergeUnits)
                {
                    Caption = 'Merge Units';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Merged Units List";
                }
                action(RentCalculation)
                {
                    Caption = 'Rent Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Rent Calculation List";
                }

                action(Paymentschedule)
                {
                    Caption = 'Payment Schedule';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Schedule List";
                }
                action(PaymentMode)
                {
                    Caption = 'Payment Mode';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Mode List";
                }





                action(PDCTransactions)
                {
                    Caption = 'PDC Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PDC Transactions";
                }
                // action(RevenueItemlist)
                // {
                //     Caption = 'Revenue Items';
                //     ApplicationArea = Basic, Suite;
                //     RunObject = Page "Primary Item List";
                // }
                // action(RevenueCategory)
                // {
                //     Caption = 'Revenue Categories';
                //     ApplicationArea = Basic, Suite;
                //     RunObject = Page "Category List";
                // }
                // action(RevenueAllocation)
                // {
                //     Caption = 'Revenue Allocation';
                //     ApplicationArea = Basic, Suite;
                //     RunObject = Page "Revenue Allocation List";
                // }



                action(AvailabilityStatus)
                {
                    Caption = 'Availability Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Availability Status List";
                }
                action(ApprovalContractStatus)
                {
                    Caption = 'Approval Contract Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Approval Contract Status List";
                }
                action(ConytractRenewal)
                {
                    Caption = 'Contract Renewal';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Contract Renewal List";
                }




                action(SecurityDeposit)
                {
                    Caption = 'Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Security Deposit List";
                }
                action(AdjustSecurityDeposit)
                {
                    Caption = 'Adjust Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page Adjustment_Security_Deposit;
                }
                action(FinalCalculation)
                {
                    Caption = 'Final Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Final Calculation List";
                }

                action(ContractEndProcessApproval)
                {
                    Caption = 'Contract End Process Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Contract End Process Approval";
                }

            }
        }

    }
}