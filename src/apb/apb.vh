`timescale 1ns / 1ps
//----------------------+-------------------------------------------------------
// Filename             | apb_interface.sv
// File created on      | 26/10/2024
// Created by           | Sree Sankar E
//                      |
//                      |
//                      |
//----------------------+-------------------------------------------------------
//
//------------------------------------------------------------------------------
// APB Interface Header
//------------------------------------------------------------------------------

    `define APB_AW      'd32 // Address Width
    `define APB_DW      'd32 // Data Width
    `define APB_STRBW   'd4  // Strobe Width
    `define APB_SLAVES  'd1  // No of Slaves

//------------------------------------------------------------------------------
// APB PSEL Position
//------------------------------------------------------------------------------

    `define APB_PSEL0   'h0