/* 
 * directus.io
 *
 * API for directus.io
 *
 * OpenAPI spec version: 1.1
 * 
 * Generated by: https://github.com/swagger-api/swagger-codegen.git
 */

using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;
using SwaggerDateConverter = IO.Directus.Client.SwaggerDateConverter;

namespace IO.Directus.Model
{
    /// <summary>
    /// GetMessagesData
    /// </summary>
    [DataContract]
    public partial class GetMessagesData :  IEquatable<GetMessagesData>, IValidatableObject
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="GetMessagesData" /> class.
        /// </summary>
        /// <param name="Id">Id.</param>
        /// <param name="From">From.</param>
        /// <param name="Subject">Subject.</param>
        /// <param name="Message">Message.</param>
        /// <param name="Attachment">Attachment.</param>
        /// <param name="Datetime">Datetime.</param>
        /// <param name="ResponseTo">ResponseTo.</param>
        /// <param name="Read">Read.</param>
        /// <param name="Responses">Responses.</param>
        /// <param name="Recipients">Recipients.</param>
        /// <param name="DateUpdated">DateUpdated.</param>
        public GetMessagesData(int? Id = default(int?), int? From = default(int?), string Subject = default(string), string Message = default(string), string Attachment = default(string), string Datetime = default(string), string ResponseTo = default(string), int? Read = default(int?), GetMessagesResponses Responses = default(GetMessagesResponses), string Recipients = default(string), string DateUpdated = default(string))
        {
            this.Id = Id;
            this.From = From;
            this.Subject = Subject;
            this.Message = Message;
            this.Attachment = Attachment;
            this.Datetime = Datetime;
            this.ResponseTo = ResponseTo;
            this.Read = Read;
            this.Responses = Responses;
            this.Recipients = Recipients;
            this.DateUpdated = DateUpdated;
        }
        
        /// <summary>
        /// Gets or Sets Id
        /// </summary>
        [DataMember(Name="id", EmitDefaultValue=false)]
        public int? Id { get; set; }

        /// <summary>
        /// Gets or Sets From
        /// </summary>
        [DataMember(Name="from", EmitDefaultValue=false)]
        public int? From { get; set; }

        /// <summary>
        /// Gets or Sets Subject
        /// </summary>
        [DataMember(Name="subject", EmitDefaultValue=false)]
        public string Subject { get; set; }

        /// <summary>
        /// Gets or Sets Message
        /// </summary>
        [DataMember(Name="message", EmitDefaultValue=false)]
        public string Message { get; set; }

        /// <summary>
        /// Gets or Sets Attachment
        /// </summary>
        [DataMember(Name="attachment", EmitDefaultValue=false)]
        public string Attachment { get; set; }

        /// <summary>
        /// Gets or Sets Datetime
        /// </summary>
        [DataMember(Name="datetime", EmitDefaultValue=false)]
        public string Datetime { get; set; }

        /// <summary>
        /// Gets or Sets ResponseTo
        /// </summary>
        [DataMember(Name="response_to", EmitDefaultValue=false)]
        public string ResponseTo { get; set; }

        /// <summary>
        /// Gets or Sets Read
        /// </summary>
        [DataMember(Name="read", EmitDefaultValue=false)]
        public int? Read { get; set; }

        /// <summary>
        /// Gets or Sets Responses
        /// </summary>
        [DataMember(Name="responses", EmitDefaultValue=false)]
        public GetMessagesResponses Responses { get; set; }

        /// <summary>
        /// Gets or Sets Recipients
        /// </summary>
        [DataMember(Name="recipients", EmitDefaultValue=false)]
        public string Recipients { get; set; }

        /// <summary>
        /// Gets or Sets DateUpdated
        /// </summary>
        [DataMember(Name="date_updated", EmitDefaultValue=false)]
        public string DateUpdated { get; set; }

        /// <summary>
        /// Returns the string presentation of the object
        /// </summary>
        /// <returns>String presentation of the object</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class GetMessagesData {\n");
            sb.Append("  Id: ").Append(Id).Append("\n");
            sb.Append("  From: ").Append(From).Append("\n");
            sb.Append("  Subject: ").Append(Subject).Append("\n");
            sb.Append("  Message: ").Append(Message).Append("\n");
            sb.Append("  Attachment: ").Append(Attachment).Append("\n");
            sb.Append("  Datetime: ").Append(Datetime).Append("\n");
            sb.Append("  ResponseTo: ").Append(ResponseTo).Append("\n");
            sb.Append("  Read: ").Append(Read).Append("\n");
            sb.Append("  Responses: ").Append(Responses).Append("\n");
            sb.Append("  Recipients: ").Append(Recipients).Append("\n");
            sb.Append("  DateUpdated: ").Append(DateUpdated).Append("\n");
            sb.Append("}\n");
            return sb.ToString();
        }
  
        /// <summary>
        /// Returns the JSON string presentation of the object
        /// </summary>
        /// <returns>JSON string presentation of the object</returns>
        public string ToJson()
        {
            return JsonConvert.SerializeObject(this, Formatting.Indented);
        }

        /// <summary>
        /// Returns true if objects are equal
        /// </summary>
        /// <param name="input">Object to be compared</param>
        /// <returns>Boolean</returns>
        public override bool Equals(object input)
        {
            return this.Equals(input as GetMessagesData);
        }

        /// <summary>
        /// Returns true if GetMessagesData instances are equal
        /// </summary>
        /// <param name="input">Instance of GetMessagesData to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(GetMessagesData input)
        {
            if (input == null)
                return false;

            return 
                (
                    this.Id == input.Id ||
                    (this.Id != null &&
                    this.Id.Equals(input.Id))
                ) && 
                (
                    this.From == input.From ||
                    (this.From != null &&
                    this.From.Equals(input.From))
                ) && 
                (
                    this.Subject == input.Subject ||
                    (this.Subject != null &&
                    this.Subject.Equals(input.Subject))
                ) && 
                (
                    this.Message == input.Message ||
                    (this.Message != null &&
                    this.Message.Equals(input.Message))
                ) && 
                (
                    this.Attachment == input.Attachment ||
                    (this.Attachment != null &&
                    this.Attachment.Equals(input.Attachment))
                ) && 
                (
                    this.Datetime == input.Datetime ||
                    (this.Datetime != null &&
                    this.Datetime.Equals(input.Datetime))
                ) && 
                (
                    this.ResponseTo == input.ResponseTo ||
                    (this.ResponseTo != null &&
                    this.ResponseTo.Equals(input.ResponseTo))
                ) && 
                (
                    this.Read == input.Read ||
                    (this.Read != null &&
                    this.Read.Equals(input.Read))
                ) && 
                (
                    this.Responses == input.Responses ||
                    (this.Responses != null &&
                    this.Responses.Equals(input.Responses))
                ) && 
                (
                    this.Recipients == input.Recipients ||
                    (this.Recipients != null &&
                    this.Recipients.Equals(input.Recipients))
                ) && 
                (
                    this.DateUpdated == input.DateUpdated ||
                    (this.DateUpdated != null &&
                    this.DateUpdated.Equals(input.DateUpdated))
                );
        }

        /// <summary>
        /// Gets the hash code
        /// </summary>
        /// <returns>Hash code</returns>
        public override int GetHashCode()
        {
            unchecked // Overflow is fine, just wrap
            {
                int hashCode = 41;
                if (this.Id != null)
                    hashCode = hashCode * 59 + this.Id.GetHashCode();
                if (this.From != null)
                    hashCode = hashCode * 59 + this.From.GetHashCode();
                if (this.Subject != null)
                    hashCode = hashCode * 59 + this.Subject.GetHashCode();
                if (this.Message != null)
                    hashCode = hashCode * 59 + this.Message.GetHashCode();
                if (this.Attachment != null)
                    hashCode = hashCode * 59 + this.Attachment.GetHashCode();
                if (this.Datetime != null)
                    hashCode = hashCode * 59 + this.Datetime.GetHashCode();
                if (this.ResponseTo != null)
                    hashCode = hashCode * 59 + this.ResponseTo.GetHashCode();
                if (this.Read != null)
                    hashCode = hashCode * 59 + this.Read.GetHashCode();
                if (this.Responses != null)
                    hashCode = hashCode * 59 + this.Responses.GetHashCode();
                if (this.Recipients != null)
                    hashCode = hashCode * 59 + this.Recipients.GetHashCode();
                if (this.DateUpdated != null)
                    hashCode = hashCode * 59 + this.DateUpdated.GetHashCode();
                return hashCode;
            }
        }

        /// <summary>
        /// To validate all properties of the instance
        /// </summary>
        /// <param name="validationContext">Validation context</param>
        /// <returns>Validation Result</returns>
        IEnumerable<System.ComponentModel.DataAnnotations.ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            yield break;
        }
    }

}
